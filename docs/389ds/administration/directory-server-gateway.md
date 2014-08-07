---
title: "Directory Server Gateway"
---

# Directory Server Gateway
--------------------------

Problems you might encounter
----------------------------

### Gateway CGI binaries segfault for no obvious reason

If you discover that the gateway CGI binaries segfault for no obvious reason check the locales and character sets accepted/requested by your web browser. I have discovered that the dsgw binaries accompanying at least Fedora DS 1.0.4 are hyper-sensitive to browser locales & character sets and some particular combinations will cause them to crash.

If using Firefox check the following settings in either your profile prefs.js or under <about:config>:

-   intl.accept\_languages: "en-US,en,en-CA,en-us,EN-US,EN,es-ES,es,no-NO,no,en-gb,ro-RO,ro,utf-8,utf,de-DE,d"

If the above configuration setting is returned to the default of "en-us, en" then the dsgw binaries function properly.

