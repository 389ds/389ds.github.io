---
title: "dsidm effective password policy lookup design"
---

# dsidm effective password policy lookup design
----------------

Overview
--------

389 Directory Server supports three layers of password policy:

- **Global policy** — defined on `cn=config`
- **Subtree local policy** — applied to an organizational unit or suffix via Class of Service (CoS)
- **User local policy** — applied directly to a single user entry

Precedence is user local, then subtree local, then global. Local policies override
global settings for the attributes they define. When
`nsslapd-pwpolicy-inherit-global` is enabled and a local policy does not enable
syntax checking locally, syntax-related settings from the global policy are merged
at evaluation time (see `new_passwdPolicy()` in `ldap/servers/slapd/pw.c`).

Administrators troubleshooting lockouts, password expiration, or syntax rejections
historically had to trace CoS definitions, policy container entries, and
`cn=config` by hand. Existing tools such as `dsconf pwpolicy get` and
`dsconf localpwp get` report policy settings for a **configuration DN**, not the
**effective policy for a user account**.

The **`dsidm user get-pwp`** command closes that gap. It resolves which policy
governs a given user, reports policy metadata (type, source DN, target DN), and
lists the effective settings the server applies. Implementation is entirely in
**lib389** (`PwPolicyManager` and a thin CLI wrapper); no server changes are
required.

Related reading:

- [Password policy](https://www.port389.org/docs/389ds/design/password-policy.html) (server design)
- `dsconf pwpolicy` / `dsconf localpwp` — configure global and local policies
- Cockpit **Local Password Policy** UI — creates user and subtree policy entries

Use Cases
---------

### Troubleshooting a lockout after subtree policy rollout

An administrator creates a subtree password policy on `ou=People,dc=example,dc=com`
with stricter lockout settings. Users in that OU start hitting lockout sooner than
expected. One affected account is `uid=william,ou=People,dc=example,dc=com`.

```bash
dsidm slapd-localhost -b dc=example,dc=com user get-pwp william
```

Expected output identifies **Subtree Policy**, shows
`passwordPolicyTarget: ou=People,dc=example,dc=com`, and lists only the settings
stored on the subtree policy entry (for example `passwordlockout: on`,
`passwordmaxfailure: 5`). If global syntax inheritance is active and the subtree
policy does not define syntax locally, inherited syntax settings appear at the end
of the list with `(inherited)`.

### User policy overriding subtree policy

Both a subtree policy and a user-specific policy exist. The user `steve` has a
local user policy that sets `passwordinhistory: 4` while the subtree policy sets
`passwordinhistory: 10`.

```bash
dsidm slapd-localhost -b dc=example,dc=com user get-pwp steve
```

Output must show **User Policy**, `passwordPolicyTarget` equal to Steve's DN, and
`passwordinhistory: 4` — not the subtree value.

### Compliance audit with JSON output

A nightly job checks that all users in `ou=contractors,dc=example,dc=com` are
governed by a subtree policy with `passwordexp: on`. The script binds with a
read-only service account and runs:

```bash
dsidm -j slapd-localhost -b dc=example,dc=com user get-pwp "$uid"
```

The job parses `policy_type`, `policy_target`, and `attrs` without scraping
text annotations. Inherited syntax attributes include a second array element
`"inherited"`.

### Global-only user with full setting inventory

A user has no local `pwdpolicysubentry` operational attribute. The command reports
**Global Policy** with `passwordPolicyDN: cn=config` and lists the complete
global effective settings (general, expiration, lockout, syntax, TPR, and related
`cn=config` flags such as `nsslapd-pwpolicy-inherit-global`).

### Failure cases

- **User not found** — non-zero exit, clear message (`User "<selector>" was not found`).
- **Broken policy reference** — user entry references a missing policy DN; non-zero
  exit with message that the assigned policy could not be found.
- **Insufficient access** — LDAP `INSUFFICIENT_ACCESS`; no partial policy report
  is emitted (same bind/ACI model as other `dsidm` read commands).

Design
------

### Scope

| In scope | Out of scope |
|----------|--------------|
| Effective policy for **user accounts** via `dsidm user` | Modifying policies (`dsconf pwpolicy`, `dsconf localpwp`) |
| Text and JSON output | Policy lookup for arbitrary DNs (`dsconf localpwp get`) |
| Syntax inheritance display (when server would merge global syntax) | Runtime password state (lockout counters, expiration timestamps on the user entry) |
| Posix, basic, service, and traditional user types (`--user-type`) | New LDAP extended operations or schema |

### Command syntax

```bash
dsidm <instance> [-b BASEDN] [-D BINDDN] [-w PASSWORD | -W | -y FILE] [-Z] \
     user get-pwp <selector>

dsidm -j <instance> ... user get-pwp <selector>
```

| Argument | Description |
|----------|-------------|
| `instance` | Instance name or LDAP URL (same as all `dsidm` commands) |
| `-b / --basedn` | Search base; defaults per `dsidm` |
| `selector` | User identifier (typically `uid` for posix users), same resolution as `user get` |
| `--user-type` | `posix` (default), `basic`, `service`, or `traditional` |
| `-j / --json` | Structured JSON output |

Implementation entry points:

- CLI handler: `src/lib389/lib389/cli_idm/user.py` — `get_pwp()`
- Core logic: `src/lib389/lib389/pwpolicy.py` — `PwPolicyManager.get_effective_policy()`

### Schema

No new schema, object classes, or attributes. The command reads existing
password policy attributes and the operational attribute `pwdpolicysubentry` on
the user entry.

### Policy type resolution

The authoritative signal for which policy applies to an **existing user** is the
operational attribute **`pwdpolicysubentry`** on the user entry (delivered by CoS
for subtree policies):

| Condition | Policy type (text / JSON) | Source DN | Target |
|-----------|---------------------------|-----------|--------|
| No `pwdpolicysubentry` | `Global Policy` | `cn=config` | `global` |
| Policy entry `cn` contains `nsPwPolicyEntry_user` | `User Policy` | Local policy entry DN | User DN (parsed from policy `cn`) |
| Policy entry `cn` contains `nsPwPolicyEntry_subtree` | `Subtree Policy` | Local policy entry DN | Subtree DN (parsed from policy `cn`) |

The policy entry `cn` value uses LDAP-escaped DN fragments (for example
`cn=nsPwPolicyEntry_user,uid\3Dsteve,...`). The implementation URL-decodes the
suffix after the prefix to obtain the policy target DN.

**Global policy output** — enumerate all password policy attributes from
`PwPolicyManager.arg_to_attr`, plus global-only configuration attributes
(`passwordisglobalpolicy`, `nsslapd-pwpolicy-local`, `nsslapd-allow-hashed-passwords`,
`nsslapd-pwpolicy-inherit-global`). Unset values are shown using server defaults
(from `pwpolicy_init_defaults()` / `LOCAL_PW_POLICY_DEFAULTS` in lib389).

**Local policy output** — show only:

1. Attributes **explicitly stored** on the local policy LDAP entry.
2. **Inherited syntax** attributes from the global policy when **all** of the
   following hold (matching `pw.c`):
   - `nsslapd-pwpolicy-inherit-global` is `on` on `cn=config`
   - Global `passwordchecksyntax` is `on`
   - Local policy does **not** have `passwordchecksyntax` enabled

Inherited syntax settings are included only when the global value is meaningful
(non-empty, not `0`, not `off`). The `passwordchecksyntax` flag itself is not
listed as an inherited line item.

**Display order** (local policies): local settings first (alphabetical), then
inherited settings (alphabetical).

Attribute names returned by LDAP use schema canonical casing (for example
`passwordHistory`); lib389 normalizes names to lowercase internally for comparison.

### Output formats

**Text** (default):

```text
dn: uid=steve,ou=people,dc=example,dc=com
passwordPolicy: User Policy
passwordPolicyDN: cn=cn\3DnsPwPolicyEntry_user\2Cuid\3Dsteve\2Cou\3Dpeople\2Cdc\3Dexample\2Cdc\3Dcom,cn=nsPwPolicyContainer,ou=people,dc=example,dc=com
passwordPolicyTarget: uid=steve,ou=people,dc=example,dc=com
------------------- Policy Settings -------------------
passwordhistory: on
passwordinhistory: 6
passwordminlength: 16 (inherited)
```

**JSON** (`-j`):

```json
{
    "dn": "uid=steve,ou=people,dc=example,dc=com",
    "policy_type": "User Policy",
    "policy_dn": "cn=cn\\3DnsPwPolicyEntry_user\\2Cuid\\3Dsteve\\2Cou\\3Dpeople\\2Cdc\\3Dexample\\2Cdc\\3Dcom,cn=nsPwPolicyContainer,ou=people,dc=example,dc=com",
    "policy_target": "uid=steve,ou=people,dc=example,dc=com",
    "attrs": {
        "passwordhistory": ["on"],
        "passwordinhistory": ["6"],
        "passwordminlength": ["16", "inherited"]
    }
}
```

Policy type labels are always **`Global Policy`**, **`User Policy`**, or
**`Subtree Policy`** in both text and JSON.

### Testing

- Unit tests: `src/lib389/lib389/tests/pwpolicy_effective_test.py`
- Integration tests: `dirsrvtests/tests/suites/clu/dsidm_user_get_pwp_test.py`
  (`pytest.mark.tier1`)

Cases covered include global, subtree, and user policies; precedence; syntax
inheritance on/off; JSON parity; not-found user; broken policy reference; and
ACL denial without information leak.

Major configuration options and enablement
------------------------------------------

The command is always available in `dsidm` once the lib389 package containing
the feature is installed. No separate server plug-in or feature flag is required.

Password policy behavior depends on existing server configuration:

| Setting | Location | Effect on `get-pwp` |
|---------|----------|---------------------|
| `nsslapd-pwpolicy-local` | `cn=config` | Must be `on` for local policies to be created/applied (unchanged by this feature) |
| `nsslapd-pwpolicy-inherit-global` | `cn=config` | When `on`, unset local syntax may appear as inherited settings in output |
| Global / local policy attributes | `cn=config` or policy entries | Values shown in command output |

There is no configuration option to enable or disable `get-pwp` itself.

External Impact
---------------

| Component | Impact |
|-----------|--------|
| **389-ds-base (ns-slapd)** | None — read-only client feature |
| **lib389 / python3-lib389** | New `dsidm user get-pwp` subcommand; extended `PwPolicyManager` API |
| **Cockpit 389 DS** | None required; UI continues to manage policies via existing APIs |
| **dsconf** | Complementary — `dsconf pwpolicy` / `dsconf localpwp` for configuration; `dsidm user get-pwp` for per-user effective view |
| **Documentation** | Wiki design (this page); `src/lib389/README.md` usage summary |
| **Downstream packaging** | Updated `python3-lib389` / `389-ds-base` RPMs ship the command |

Origin
-------------

https://github.com/389ds/389-ds-base/issues/7505

Author
------

<mreynolds@redhat.com>
