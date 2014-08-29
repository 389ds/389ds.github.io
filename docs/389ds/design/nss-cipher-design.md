---
title: "Supported Ciphers in 389-ds-base"
---

# Supported Ciphers in 389-ds-base
----------------------------------

{% include toc.md %}

Overview
========

Directory Server supports SSL and StartTLS for the secure connections. The ciphers to encrypt the data are provided by NSS which the Directory Server is linked with. Note: The following list contains up to TLS1.2, which is available >= nss 3.15

Configuration
=============

To configure the ciphers for the Directory Server, the config parameter nsSSL3Ciphers in cn=encryption,cn=config is used.

Sample encryption entry:

    dn: cn=encryption,cn=config
    objectClass: top
    objectClass: nsEncryptionConfig
    cn: encryption
    nsSSLSessionTimeout: 0
    nsSSLClientAuth: allowed
    nsSSL2: off
    nsSSL3: on
    nsSSL3Ciphers: default
    nsKeyfile: alias/slapd-ID-key3.db
    nsCertfile: alias/slapd-ID-cert8.db

-   If **nsSSL3Ciphers** does not exist or the value is "default", the default ciphers are enabled. Note: the keyword "default" is newly introduced to 389-ds-base-1.3.3 (https://fedorahosted.org/389/ticket/47838).

    The default cipher set is returned by **SSL_CipherPrefGetDefault** using the feature -- if the application has not previously set the default preference, **SSL_CipherPrefGetDefault** returns the factory setting. See "Enabled by default (with no nsSSL3Ciphers or nsSSL3Ciphers: default)"

-   If the value of **nsSSL3Ciphers** is "+all", all the available ciphers are enabled.

    See "Available by setting +all" and "Available by setting +all but weak"

-   If the value of **nsSSL3Ciphers** is "-all", no ciphers are enabled. If the SSL is enabled "nsSSL3: on", the server does not start.

-   If the value of **nsSSL3Ciphers** is the list of ciphers, the specified ciphers are enabled. + means enable it, - means disable it. E.g.,

        nsSSL3Ciphers: -rsa_null_md5,+rsa_rc4_128_md5,+rsa_rc4_40_md5,+rsa_rc2_40_md5,
         +rsa_des_sha,+rsa_fips_des_sha,+rsa_3des_sha,+rsa_fips_3des_sha,+fortezza,
         +fortezza_rc4_128_sha,+fortezza_null,+tls_rsa_export1024_with_rc4_56_sha,
         +tls_rsa_export1024_with_des_cbc_sha,-rc4,-rc4export,-rc2,-rc2export,
         -des,-desede3

    Notes: if the value contains +all, then **-\<cipher\>** is removed from the list. Otherwise, **-\<cipher\>** is not necessary. The lower case cipher names are proprietary hardcoded in the Directory Server code. They are still usable in the nsSSL3Ciphers value, but deprecated. The cipher suite names defined in NSS (see the following tables) are recommended to use. The above example is replaced with:

        nsSSL3Ciphers: -TLS_RSA_WITH_NULL_MD5,+TLS_RSA_WITH_RC4_128_MD5,
         +TLS_RSA_EXPORT_WITH_RC4_40_MD5,+TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5,
         +TLS_DHE_RSA_WITH_DES_CBC_SHA,+SSL_RSA_FIPS_WITH_DES_CBC_SHA,
         +TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA,+SSL_RSA_FIPS_WITH_3DES_EDE_CBC_SHA,
         +TLS_RSA_EXPORT1024_WITH_RC4_56_SHA,+TLS_RSA_EXPORT1024_WITH_DES_CBC_SHA,
         -SSL_CK_RC4_128_WITH_MD5,-SSL_CK_RC4_128_EXPORT40_WITH_MD5,
         -SSL_CK_RC2_128_CBC_WITH_MD5,-SSL_CK_RC2_128_CBC_EXPORT40_WITH_MD5,
         -SSL_CK_DES_64_CBC_WITH_MD5,-SSL_CK_DES_192_EDE3_CBC_WITH_MD5

-   The ciphers in the unavailable list are not allowed to be enabled.

Cipher List
===========

Enabled by default (with no nsSSL3Ciphers or nsSSL3Ciphers: default) -- nss-3.16.2-1 
------------------------------------------------------------------------------------


| NSS Cipher Suite Name | 389-ds-base keyword (deprecated) |
|-----------------------|----------------------------------|
|TLS_DHE_RSA_WITH_AES_128_GCM_SHA256|tls_dhe_rsa_aes_128_gcm_sha|
|TLS_DHE_RSA_WITH_AES_128_CBC_SHA|tls_dhe_rsa_aes_128_sha|
|TLS_DHE_DSS_WITH_AES_128_CBC_SHA|tls_dhe_dss_aes_128_sha|
|TLS_DHE_RSA_WITH_AES_256_CBC_SHA|tls_dhe_rsa_aes_256_sha|
|TLS_DHE_DSS_WITH_AES_256_CBC_SHA|tls_dhe_dss_aes_256_sha|
|TLS_DHE_RSA_WITH_AES_128_CBC_SHA256||
|TLS_DHE_RSA_WITH_AES_256_CBC_SHA256||
|TLS_RSA_WITH_AES_128_GCM_SHA256|tls_rsa_aes_128_gcm_sha|
|TLS_RSA_WITH_AES_128_CBC_SHA|tls_rsa_aes_128_sha<br>rsa_aes_128_sha|
|TLS_RSA_WITH_AES_128_CBC_SHA256||
|TLS_RSA_WITH_AES_256_CBC_SHA|tls_rsa_aes_256_sha<br>rsa_aes_256_sha|
|TLS_RSA_WITH_AES_256_CBC_SHA256||


Available by setting +all -- nss-3.16.2-1 
-----------------------------------------


| NSS Cipher Suite Name | 389-ds-base keyword (deprecated) |
|-----------------------|----------------------------------|
|SSL_CK_DES_192_EDE3_CBC_WITH_MD5 |desede3 |
|SSL_CK_DES_64_CBC_WITH_MD5 |des |
|SSL_CK_RC2_128_CBC_EXPORT40_WITH_MD5 |rc2export |
|SSL_CK_RC2_128_CBC_WITH_MD5 | rc2 |
|SSL_CK_RC4_128_EXPORT40_WITH_MD5 | rc4export |
|SSL_CK_RC4_128_WITH_MD5 |rc4 |
|SSL_RSA_FIPS_WITH_3DES_EDE_CBC_SHA |fips_3des_sha<br>rsa_fips_3des_sha |
|SSL_RSA_FIPS_WITH_DES_CBC_SHA |fips_des_sha<br>rsa_fips_des_sha |
|TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA |dhe_dss_3des_sha |
|TLS_DHE_DSS_WITH_AES_128_CBC_SHA |tls_dhe_dss_aes_128_sha |
|TLS_DHE_DSS_WITH_AES_256_CBC_SHA |tls_dhe_dss_aes_256_sha |
|TLS_DHE_DSS_WITH_DES_CBC_SHA |dhe_dss_des_sha |
|TLS_DHE_DSS_WITH_RC4_128_SHA |tls_dhe_dss_rc4_128_sha |
|TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA |dhe_rsa_3des_sha |
|TLS_DHE_RSA_WITH_AES_128_CBC_SHA |tls_dhe_rsa_aes_128_sha |
|TLS_DHE_RSA_WITH_AES_128_GCM_SHA256 |tls_dhe_rsa_aes_128_gcm_sha |
|TLS_DHE_RSA_WITH_AES_256_CBC_SHA |tls_dhe_rsa_aes_256_sha |
|TLS_DHE_RSA_WITH_DES_CBC_SHA |dhe_rsa_des_sha |
|TLS_RSA_EXPORT1024_WITH_DES_CBC_SHA |rsa_des_56_sha<br>tls_rsa_export1024_with_des_cbc_sha |
|TLS_RSA_EXPORT1024_WITH_RC4_56_SHA |rsa_rc4_56_sha<br>tls_dhe_dss_1024_rc4_sha<br>tls_rsa_export1024_with_rc4_56_sha |
|TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5 |rsa_rc2_40_md5 | tls_rsa_rc2_40_md5 |
|TLS_RSA_EXPORT_WITH_RC4_40_MD5 |rsa_rc4_40_md5 | tls_rsa_rc4_40_md5 |
|TLS_RSA_WITH_3DES_EDE_CBC_SHA |rsa_3des_sha | tls_rsa_3des_sha |
|TLS_RSA_WITH_AES_128_CBC_SHA |rsa_aes_128_sha |
|TLS_RSA_WITH_AES_128_CBC_SHA |tls_rsa_aes_128_sha |
|TLS_RSA_WITH_AES_128_GCM_SHA256 |tls_rsa_aes_128_gcm_sha |
|TLS_RSA_WITH_AES_256_CBC_SHA |rsa_aes_256_sha |
|TLS_RSA_WITH_AES_256_CBC_SHA |tls_rsa_aes_256_sha |
|TLS_RSA_WITH_DES_CBC_SHA |rsa_des_sha |
|TLS_RSA_WITH_RC4_128_MD5 |rsa_rc4_128_md5 |
|TLS_RSA_WITH_RC4_128_SHA |rsa_rc4_128_sha |
|TLS_DHE_DSS_WITH_CAMELLIA_128_CBC_SHA | |
|TLS_DHE_DSS_WITH_CAMELLIA_256_CBC_SHA | |
|TLS_DHE_RSA_WITH_AES_128_CBC_SHA256 | |
|TLS_DHE_RSA_WITH_AES_256_CBC_SHA256 | |
|TLS_DHE_RSA_WITH_CAMELLIA_128_CBC_SHA | |
|TLS_DHE_RSA_WITH_CAMELLIA_256_CBC_SHA | |
|TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDH_ECDSA_WITH_AES_128_CBC_SHA | |
|TLS_ECDH_ECDSA_WITH_AES_256_CBC_SHA | |
|TLS_ECDH_ECDSA_WITH_NULL_SHA | |
|TLS_ECDH_ECDSA_WITH_RC4_128_SHA | |
|TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA | |
|TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256 | |
|TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256 | |
|TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA | |
|TLS_ECDHE_ECDSA_WITH_NULL_SHA | |
|TLS_ECDHE_ECDSA_WITH_RC4_128_SHA | |
|TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA | |
|TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256 | |
|TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256 | |
|TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA | |
|TLS_ECDHE_RSA_WITH_NULL_SHA | |
|TLS_ECDHE_RSA_WITH_RC4_128_SHA | |
|TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDH_RSA_WITH_AES_128_CBC_SHA | |
|TLS_ECDH_RSA_WITH_AES_256_CBC_SHA | |
|TLS_ECDH_RSA_WITH_NULL_SHA | |
|TLS_ECDH_RSA_WITH_RC4_128_SHA | |
|TLS_RSA_WITH_AES_128_CBC_SHA256 | |
|TLS_RSA_WITH_AES_256_CBC_SHA256 | |
|TLS_RSA_WITH_CAMELLIA_128_CBC_SHA | |
|TLS_RSA_WITH_CAMELLIA_256_CBC_SHA | |
|TLS_RSA_WITH_NULL_MD5 | |
|TLS_RSA_WITH_NULL_SHA256 | |
|TLS_RSA_WITH_NULL_SHA | |
|TLS_RSA_WITH_SEED_CBC_SHA | |


Available by setting +all but weak -- nss-3.16.2-1 
--------------------------------------------------

| NSS Cipher Suite Name | 389-ds-base keyword (deprecated) |
|-----------------------|----------------------------------|
|SSL_CK_DES_192_EDE3_CBC_WITH_MD5 |desede3 |
|SSL_CK_DES_64_CBC_WITH_MD5 |des |
|SSL_CK_RC2_128_CBC_EXPORT40_WITH_MD5 |rc2export |
|SSL_CK_RC2_128_CBC_WITH_MD5 |rc2 |
|SSL_CK_RC4_128_EXPORT40_WITH_MD5 |rc4export |
|SSL_CK_RC4_128_WITH_MD5 |rc4 |
|SSL_RSA_FIPS_WITH_3DES_EDE_CBC_SHA |fips_3des_sha<br>rsa_fips_3des_sha |
|SSL_RSA_FIPS_WITH_DES_CBC_SHA |fips_des_sha<br>rsa_fips_des_sha |
|TLS_DHE_DSS_WITH_3DES_EDE_CBC_SHA |dhe_dss_3des_sha |
|TLS_DHE_DSS_WITH_DES_CBC_SHA |dhe_dss_des_sha |
|TLS_DHE_DSS_WITH_RC4_128_SHA |tls_dhe_dss_rc4_128_sha |
|TLS_DHE_RSA_WITH_3DES_EDE_CBC_SHA |dhe_rsa_3des_sha |
|TLS_DHE_RSA_WITH_DES_CBC_SHA |dhe_rsa_des_sha |
|TLS_ECDH_ECDSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDH_ECDSA_WITH_RC4_128_SHA | |
|TLS_ECDHE_ECDSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDHE_ECDSA_WITH_RC4_128_SHA | |
|TLS_ECDHE_RSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDHE_RSA_WITH_RC4_128_SHA | |
|TLS_ECDH_RSA_WITH_3DES_EDE_CBC_SHA | |
|TLS_ECDH_RSA_WITH_RC4_128_SHA | |
|TLS_RSA_EXPORT1024_WITH_DES_CBC_SHA |rsa_des_56_sha<br>tls_rsa_export1024_with_des_cbc_sha |
|TLS_RSA_EXPORT1024_WITH_RC4_56_SHA |rsa_rc4_56_sha<br>tls_dhe_dss_1024_rc4_sha<br>tls_rsa_export1024_with_rc4_56_sha |
|TLS_RSA_EXPORT_WITH_RC2_CBC_40_MD5 |rsa_rc2_40_md5<br>tls_rsa_rc2_40_md5 |
|TLS_RSA_EXPORT_WITH_RC4_40_MD5 |rsa_rc4_40_md5<br>tls_rsa_rc4_40_md5 |
|TLS_RSA_WITH_3DES_EDE_CBC_SHA |rsa_3des_sha<br>tls_rsa_3des_sha |
|TLS_RSA_WITH_DES_CBC_SHA |rsa_des_sha |
|TLS_RSA_WITH_RC4_128_MD5 |rsa_rc4_128_md5 |
|TLS_RSA_WITH_RC4_128_SHA |rsa_rc4_128_sha |


Unavailable -- nss-3.16.2-1 
---------------------------

| NSS Cipher Suite Name | 389-ds-base keyword (deprecated) |
|-----------------------|----------------------------------|
|SSL_FORTEZZA_DMS_WITH_FORTEZZA_CBC_SHA |fortezza |
|SSL_FORTEZZA_DMS_WITH_RC4_128_SHA |fortezza_rc4_128_sha |
|SSL_FORTEZZA_DMS_WITH_NULL_SHA |fortezza_null |
|TLS_DH_DSS_WITH_AES_128_CBC_SHA |tls_dh_dss_aes_128_sha |
|TLS_DH_RSA_WITH_AES_128_CBC_SHA |tls_dh_rsa_aes_128_sha |
|TLS_DH_DSS_WITH_AES_256_CBC_SHA |tls_dss_aes_256_sha |
|TLS_RSA_WITH_AES_256_CBC_SHA |tls_rsa_aes_256_sha |
|TLS_DH_RSA_WITH_AES_256_CBC_SHA |tls_rsa_aes_256_sha |
|TLS_DH_DSS_WITH_CAMELLIA_128_CBC_SHA | |
|TLS_DH_RSA_WITH_CAMELLIA_128_CBC_SHA  | |
|TLS_DH_DSS_WITH_CAMELLIA_256_CBC_SHA | |
|TLS_DH_RSA_WITH_CAMELLIA_256_CBC_SHA | |
|TLS_DHE_DSS_WITH_AES_128_GCM_SHA256 |tls_dhe_dss_aes_128_gcm_sha |
|TLS_ECDH_ECDSA_WITH_AES_128_GCM_SHA256 | |
|TLS_ECDH_RSA_WITH_AES_128_GCM_SHA256 | |
|TLS_ECDHE_ECDSA_WITH_NULL_SHA | |
|TLS_ECDHE_RSA_WITH_NULL_SHA | |
|TLS_ECDH_RSA_WITH_NULL_SHA | |
|TLS_ECDH_ECDSA_WITH_NULL_SHA | |
|TLS_RSA_WITH_NULL_SHA |rsa_null_sha |
|TLS_RSA_WITH_NULL_SHA256 | |
|TLS_RSA_WITH_NULL_MD5 |rsa_null_md5 |


Logging
=======

The enabled cipher list is logged in the error log (/var/log/dirsrv/slapd-ID/errors) at the startup. E.g.,

    [..] - SSL alert: Configured NSS Ciphers
    [..] - SSL alert:   TLS_RSA_WITH_AES_128_GCM_SHA256: enabled
    [..] - SSL alert:   TLS_RSA_WITH_AES_128_CBC_SHA: enabled
    [..] - SSL alert:   TLS_RSA_WITH_AES_128_CBC_SHA256: enabled

If the config log level is set, all the ciphers are logged with "enabled" or "disabled". The weak ciphers are also noted. E.g.,

    [..] - SSL alert: Configured NSS Ciphers
    [..] - SSL alert:   TLS_DHE_DSS_WITH_DES_CBC_SHA: disabled, (WEAK CIPHER)
    [..] - SSL alert:   TLS_RSA_WITH_NULL_SHA: disabled, (MUST BE DISABLED)
    [..] - SSL alert:   TLS_RSA_WITH_CAMELLIA_256_CBC_SHA: enabled


