---
title: "Legacy Command Changes"
---

As of version 1.4.x, we have fully deprecated the perl and shell wrappers
that were provided by the project. This is a list of commands and their new mappings.

    bak2db -> dsctl <instance> bak2db
    bak2db.pl -> dsctl <instance> bak2db
    cleanallruv.pl -> dsconf <instance> repl-tasks cleanallruv
    db2bak -> dsctl <instance> db2bak
    db2bak.pl -> dsctl <instance> db2bak
    db2index -> dsconf <instance> backend index reindex
    db2index.pl -> dsconf <instance> backend index reindex
    db2ldif -> dsctl <instance> db2ldif
    db2ldif.pl -> dsctl <instance> db2ldif
    dbmon.sh -> dsconf <instance> backend monitor
    dbverify -> dsctl <instance> dbverify
    dn2rdn -> REMOVED
    fixup-linkedattrs.pl -> dsconf <instance> plugin linkedattr fixup <basedn>
    fixup-memberof.pl -> dsconf <instance> plugin memberof fixup
    ldif2db -> dsctl <instance> ldif2db
    ldif2db.pl -> dsctl <instance> ldif2db
    ldif2ldap -> REMOVED
    migrate-ds.pl -> REMOVED
    monitor -> dsconf <instance> monitor server
    ns-accountstatus.pl -> dsidm <instance> account status
    ns-activate.pl -> dsidm <instance> account unlock
    ns-inactivate.pl -> dsidm <instance> account lock
    ns-newpwpolicy.pl -> dsconf <instance> localpwp
    remove-ds.pl -> dsctl <instance> remove
    restart-dirsrv -> dsctl <instance> restart
    restoreconfig -> REMOVED
    saveconfig -> REMOVED
    schema-reload.pl -> dsconf <instance> schema reload
    setup-ds.pl -> dscreate
    start-dirsrv -> dsctl <instance> start
    status-dirsrv -> dsctl <instance> status
    stop-dirsrv -> dsctl <instance> stop
    suffix2instance -> REMOVED
    syntax-validate.pl -> REMOVED
    upgradedb -> REMOVED
    upgradednformat -> REMOVED
    usn-tombstone-cleanup.pl -> dsconf <instance> plugin usn cleanup
    verify-db.pl -> dsctl <instance> dbverify
    vlvindex -> dsconf <instance> backend vlv-index reindex

William Brown, SUSE Labs <wbrown at suse.de>
