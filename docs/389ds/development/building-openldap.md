---
title: "Building OpenLDAP"
---

# Building OpenLDAP
-------------------


### Checkout the Source

    git clone git://git.openldap.org/openldap.git

### Prepare the Build Environment

OpenLDAP expects NSS and NSPR includes to be found in **/usr/include/nss & /usr/include/nspr**.  Create symlinks if ncessary:

    ln -s /usr/include/nss3 /usr/include/nss
    ln -s /usr/include/nspr4 /usr/include/nspr


### Build OpenLDAP

    CPPFLAGS='-I/usr/include/nspr4 -I/usr/include/nss3' CFLAGS='-g -fPIC -fpie -Wall,--as-needed -DLDAP_CONNECTIONLESS' ./configure --enable-debug --enable-dynamic --enable-syslog  --enable-proctitle --enable-ipv6 --enable-local --enable-slapd --enable-dynacl --enable-aci  --enable-cleartext  --enable-crypt --enable-lmpasswd --enable-spasswd --enable-modules --enable-rewrite  --enable-rlookups --enable-slapi --disable-slp --enable-wrappers --enable-backends=mod --enable-bdb=yes --enable-hdb=yes --enable-mdb=yes --enable-monitor=yes --disable-ndb --enable-overlays=mod --disable-static --enable-shared --with-cyrus-sasl --without-fetch --with-threads --with-pic --with-tls=moznss --with-gnu-ld

    make install

### Testing the New Build
-------------------------

#### Clients

To test client tools like ldapsearch and ldapmodify you need to use the ones found in **/usr/local/bin**

    /usr/local/bin/ldapsearch
    /usr/local/bin/ldapmodify
    /usr/local/bin/ldappasswd

#### Server

You need to replace the existing openldap libraries so the server can use the new ones, please make sure you back up the originals

Make the backup

    mkdir /backup
    cp /usr/lib/libldap* /backup

Copy in the new libaries (*e.g. libldap-2-devel.so.0.0.0*), replacing the existing versioned libraries (*e.g. libldap-2.4.so.2.10.2*)

    stop-dirsrv    
    cd /lib64
    cp libldap-2-devel.so.0.0.0 libldap-2.4.so.2.10.2
    cp libldap_r-2-devel.so.0.0.0 libldap_r-2.4.so.2.10.2
    start-dirsrv


