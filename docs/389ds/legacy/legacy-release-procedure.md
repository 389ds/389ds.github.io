---
title: "Legacy Release Procedure"
---

# Fedora Directory Server Release Procedure
-----------------------------------------

These instructions no longer apply to Fedora releases, but they do apply to dsbuild (One Step Build) instructions that can build from source.

### Making the mozilla-components source tarball

For Fedora DS 1.0.2 we are using the following tags and modules from MOZCVSROOT=":pserver:anonymous@cvs-mirror.mozilla.org:/cvsroot"

    NSPRTAG=NSPR_4_6_RTM_HPUX_IPF    
    NSPRMOD=mozilla/nsprpub    

    NSSTAG=NSS_3_11_RTM    
    NSSMOD="mozilla/security/nss mozilla/security/coreconf mozilla/dbm mozilla/security/dbm"    

    SVRCORETAG=SVRCORE_4_0_1_RTM    
    SVRCOREMOD=mozilla/security/svrcore    

    LDAPSDKTAG=LDAPCSDK_5_1_7_RTM    
    LDAPSDKMOD=DirectorySDKSourceC    

    PERLDAPTAG=devel-branch-1_4_2    
    PERLDAPMOD=mozilla/directory/perldap    

For each of the above, do

    cvs -z3 -Q export -r$TAG $MODULE    

This will put everything into a top level directory called mozilla. Then

    tar cf - mozilla | gzip > mozilla-components-$VERSION.tar.gz    

Where \$VERSION is a string like "1.0.2" i.e. the current release version of Fedora DS.

Push the tarball to /var/www/html/sources on the wiki site. If you have any patches, upload those also.

### Making the Fedora components source tarballs

Fedora DS 1.0.2 uses the following modules and tags:

    ADMINUTILTAG=FedoraAdminutil102    
    ADMINUTILMOD=adminutil    

    SETUPUTILTAG=FedoraSetuputil102    
    SETUPUTILMOD=setuputil    

    CONSOLETAG=FedoraConsole102    
    CONSOLEMOD=console    

    MODNSSTAG=mod_nss102    
    MODNSSMOD=mod_nss    

    MODADMSERVTAG=mod_admserv102    
    MODADMSERVMOD=mod_admserv    

    MODRESTARTDTAG=mod_restartd102    
    MODRESTARTDMOD=mod_restartd    

    ADMINSERVERTAG=FedoraAdminserver102    
    ADMINSERVERMOD=adminserver    

    DIRCONSOLETAG=FedoraDirectoryconsole102    
    DIRCONSOLEMOD=directoryconsole    

    ONLINEHELPTAG=FedoraOnlinehelp102    
    ONLINEHELPMOD=onlinehelp    

    LDAPSERVERTAG=FedoraDirSvr102    
    LDAPSERVERMOD=ldapserver    

For each component, export the CVS sources into a directory called fedora-\$MOD-\$VERSION e.g. something like this:

    cvs -z3 -Q export -rFedoraAdminutil102 -d fedora-adminutil-1.0.2 adminutil    

then create the tgz:

    tar cf - fedora-adminutil-1.0.2 | gzip > fedora-adminutil-1.0.2.tar.gz    

The only exception to the naming convention is ldapserver, which uses a CVS tag like FedoraDirSvr and the source tarball is called fedora-ds-\$VERSION.

Push the tarballs to /var/www/html/sources on the wiki site. If you have any patches, upload those also.

### Making the dsbuild tarball

After a source tarball has changed, you need to regenerate the checksums. You may also need to change the Makefiles or make other changes if you have patches.

Checkout dsbuild from cvs.fedora:

    cvs co dsbuild    

Regenerate all of the checksums from the sources directory on the download site:

    cd dsbuild/meta/ds    
    make NOCACHE=1 dochecksums    

If you just need to regenerate 1 or 2 checksums, it might be faster to go into each directory e.g.

    cd dsbuild/ds/adminutil    
    make NOCACHE=1 makesum    

Use the NOCACHE=1 option because the caching proxy may be caching the older version of the source tarball (if you updated one with the same name e.g. a new version of fedora-adminutil-1.0.2.tar.gz).

Checkin and tag your changes:

    cvs ci dsbuild    
    cvs tag $TAG dsbuild    

Use cvs status -v to see the existing tags, and use the same format if you need to create a new tag. If you need to retag something for a release, use -F e.g. if you have already tagged dsbuild with FedoraDirSvr102, and you have fixed a bug that you would like to get into the release:

    cvs co dsbuild # NOTE: no tag - checkout from HEAD    
    cd dsbuild/ds/ldapserver # or whatever component you fixed and generated a new source tgz for    
    make NOCACHE=1 makesum    
    cvs diff checksums # review new checksums    
    cvs ci -m "message" checksums    
    cvs status -v checksums # review existing tags    
    cvs tag -F $TAG checksums # do this for each tag you need to update    

Create dsbuild tarball:

    cvs export -r$TAG -d dsbuild-fds$NODOTVERSION dsbuild    
    tar cf - dsbuild-fds$NODOTVERSION | gzip > dsbuild-fds$NODOTVERSION.tar.gz    

where \$NODOTVERSION is the no dot version e.g. 102, not 1.0.2.

Then push the dsbuild tarball to /var/www/html/sources on the wiki site.

### Doing a build

This is mostly the same as the instructions on [Building](Building "wikilink"), but you can do this:

    wget {{ site.baseurl }}/binaries/dsbuild-fds$RELEASE.tar.gz
    gunzip -c dsbuild-fds$RELEASE.tar.gz | tar xf -    
    cd dsbuild-fds$RELEASE/meta/ds    
    make BUILD_RPM=1 2>&1 | tee logfile    

