---
title: "Plugin v4 api design"
---

### Overview

Directory Server has had 3 plugin APIs so far. They have been very sucessful, and are still supported to this day.

However, they are starting to show their limits in design and with tools. We are unable to use correct modern type assertions to our interfaces (slapi_pblock_get/set), we rely on macros in many locations, and the transaction model is limited.

This is a proposal for a version 4 plugin system that lifts many of these limitations, while
still being able to support the existing plugin v1 through v3 api.

#### v3 limitations.

* Plugins may operate outside of a transaction. This means that search and modify create an implied transaction. Along with the use of mutexes, this has caused
many deadlock conditions in the past.
* Plugins assume transactions are writeable. This limits our ability to parallelise the server with lmdb/cow structures as search assumes write.
* Plugins must send their own results to the client. As the plugin framework, we should send all results based on plugin result codes.
* Plugins must find their own configuration, generally in custom methods. This ranges from attributes on the configuration, to subentries. Plugins try to lock on the config to update it by intercepting modifications.
* Plugins use a function signature with a return type of int. Int is a non-deterministic length. The plugin framework generally only checks != 0, instead of using it to communicate.
* Plugins often have to manage memory via the pblock. The pblock should be responsible for *everything* it owns, and plugins should never need to free a pblock item.
* Pblock is based on void pointers and macros, with a 2000 line case switch. It's hard to account for and validate the api.

### v4 suggestions

This is *not* a backwards compatible change. Plugins must be *redesigned* to work.

#### Pblock v4

* Complete use of inttypes.h, with explicit sizings. No more int, long, long long (which are all variable length!!!).
* The pblock is responsibile for the ownership of all memory given to it. If you set an SDN into the pblock, the pblock *will* free it.
* The pblock must not be given a type from the stack (free of a stack element == segfault).
* The pblock must never be accessed as a struct: only via function accessors.
* pblock accessors as functions should take the style of:

    const *Slapi_DN
    slapi_v4_pblock_get_target_address(Slapi_PBlock *pb) {
        if (pb == NULL || pb->pb_op == NULL) {
            return NULL;
        }
        return (const *Slapi_DN)pb->pb_op->target_address;
    }

The reason for this is you have a const type from the pblock (you shouldn't change it without using set), you have proper checks of the value, the struct is abstract from the api (and can now be changed), no need to use macros, it is externally portable to other languages who wish to access libslapd.

#### Plugin API

* Complete use of inttypes.h, with explicit sizings. No more int, long, long long (which are all variable length!!!).
* All plugin operations are within a transaction
* Guarantees of atomicity of configuration and plugin private data during every operation. Plugins should not need a mutex inside them!
* The transaction may be read only or read and write
* Plugins should return a plugin result type. For example

    enum uint64_t {
        SLAPI_V4_PLUGIN_SUCCESS,
        SLAPI_V4_PLUGIN_FAILURE
    } typedef slapi_v4_plugin_result_codes;

    struct _slapi_v4_plugin_result {
        slapi_v4_plugin_result_codes result,
        char *msg,
    } typedef slapi_v4_plugin_result;

Now the plugin function signature would be:

    slapi_v4_plugin_result *
    some_plugin_callback_fn(Slapi_PBlock) {
        if (result) {
            // Hey, everthing worked
            slapi_v4_plugin_result *res = slapi_v4_plugin_result_new(SLAPI_V4_PLUGIN_SUCCESS, "Operation on X succeeded");
            return res;
        } else {
            // Ruh roh.
            slapi_v4_plugin_result *res = slapi_v4_plugin_result_new(SLAPI_V4_PLUGIN_FAILURE, "Operation on X failed");
            return res;
        }
    }


The plugin framework on SUCCESS, if the log level was at a level IE PLUGIN or TRACE, we would see the success message in the log.

During normal operation, if the plugin failed, we would log at the ERR level the message in the result, along with the code. This message could be plugged into send_ldap_result code also. This result struct could be expanded to contain an ldap result code, and message to be sent.

* Plugins should have access to a set of apis that allows them to access their configuration. IE "get_config_attr("x")" from the cn=<plugin>,cn=plugins, or "get_subconfig_attr("y", "x")" which would get x from "cn=y,cn=<plugin>,cn=plugins".
* No more public macros. The use of enums would be requried (for example, the function hook names).

#### Plugin function hooks

The following function registration points are proposed. This is not an exhaustive list.

    SLAPI_V4_PLUGIN_RO_PRE_BIND_FN
    SLAPI_V4_PLUGIN_RO_PRE_COMPARE_FN
    SLAPI_V4_PLUGIN_RO_PRE_ENTRY_FN
    SLAPI_V4_PLUGIN_RO_PRE_EXTOP_FN
    SLAPI_V4_PLUGIN_WR_PRE_EXTOP_FN
    SLAPI_V4_PLUGIN_RO_PRE_REFERRAL_FN
    SLAPI_V4_PLUGIN_RO_PRE_RESULT_FN
    SLAPI_V4_PLUGIN_RO_PRE_SEARCH_FN
    SLAPI_V4_PLUGIN_RO_PRE_UNBIND_FN
    SLAPI_V4_PLUGIN_WR_PRE_ADD_FN
    SLAPI_V4_PLUGIN_WR_PRE_DELETE_FN
    SLAPI_V4_PLUGIN_WR_PRE_DELETE_TOMBSTONE_FN
    SLAPI_V4_PLUGIN_WR_PRE_MODIFY_FN
    SLAPI_V4_PLUGIN_WR_PRE_MODRDN_FN
    SLAPI_V4_PLUGIN_RO_EXTOP_FN
    SLAPI_V4_PLUGIN_WR_EXTOP_FN
    SLAPI_V4_PLUGIN_WR_POST_ADD_FN
    SLAPI_V4_PLUGIN_WR_POST_DELETE_FN
    SLAPI_V4_PLUGIN_WR_POST_MODIFY_FN
    SLAPI_V4_PLUGIN_WR_POST_MODRDN_FN
    SLAPI_V4_PLUGIN_RO_POST_ABANDON_FN
    SLAPI_V4_PLUGIN_RO_POST_BIND_FN
    SLAPI_V4_PLUGIN_WR_POST_BIND_FN
    SLAPI_V4_PLUGIN_RO_POST_COMPARE_FN
    SLAPI_V4_PLUGIN_RO_POST_ENTRY_FN
    SLAPI_V4_PLUGIN_RO_POST_EXTOP_FN
    SLAPI_V4_PLUGIN_WR_POST_EXTOP_FN
    SLAPI_V4_PLUGIN_RO_POST_REFERRAL_FN
    SLAPI_V4_PLUGIN_RO_POST_RESULT_FN
    SLAPI_V4_PLUGIN_RO_POST_SEARCH_FAIL_FN
    SLAPI_V4_PLUGIN_RO_POST_SEARCH_FN
    SLAPI_V4_PLUGIN_RO_POST_UNBIND_FN
    SLAPI_V4_PLUGIN_PASSWORD_QUALITY_FN
    SLAPI_V4_PLUGIN_PASSWORD_STORE_FN
    SLAPI_V4_PLUGIN_PASSWORD_VERIFICATION_FN
    SLAPI_V4_PLUGIN_START_FN
    SLAPI_V4_PLUGIN_STOP_FN
    SLAPI_V4_PLUGIN_DESTROY_FN
    SLAPI_V4_PLUGIN_RO_BEGIN_FN
    SLAPI_V4_PLUGIN_RO_CLOSE_FN
    SLAPI_V4_PLUGIN_WR_BEGIN_FN
    SLAPI_V4_PLUGIN_WR_ABORT_FN
    SLAPI_V4_PLUGIN_WR_COMMIT_FN

#### External plugins and transactions

In the list of proposed function hooks, you will notice these types.

    SLAPI_V4_PLUGIN_RO_BEGIN_FN
    SLAPI_V4_PLUGIN_RO_CLOSE_FN
    SLAPI_V4_PLUGIN_WR_BEGIN_FN
    SLAPI_V4_PLUGIN_WR_ABORT_FN
    SLAPI_V4_PLUGIN_WR_COMMIT_FN

These allow an external plugin to register for events related to transactions. For example, if the kdc were bound to these, it could allow transactions in the kdc to be synced with transaction in the Directory Server. This is vital for external password databases for example. This allows better, generic behaviour of plugins, without needing complex hacks, and keeping them in sync with Directory Server behaviours.

#### Limitations of new design

* Mixing v3 and v4 plugins will cause the related RO transaction types of the V4 system to become write transactions (depending on design). For example, a v3 pre_search plugin, would cause the v4 ro pre search to become write transaction. This has parallelism impacts.
* It's not fully fleshed out yet. There are still ideas to be had and designs to improve!
* No consideration of backend changes yet.
* Requires a lot of group work before it can be realised.
* Adding more code that needs supporting.
* Versioning in the function names may limit us if we ever decide to do v5

#### Benefits

* More clear definition of supported apis
* Type checking benefits from compiler
* Parallelism benefits
* Plugins become safer and more isolated
* Potential to deprecate APIs (older plugin APIs, or newer ones)

