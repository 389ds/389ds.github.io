---
title: "Howto: CertMapping"
---

# Certificate Mapping
---------------------

389 supports TLS (aka SSL), including support for having clients authenticate themselves with their X.509 user certificate. This is known or referred to as client certificate based authentication. The user's identity naming attributes are contained in the certificate field known as subjectDN. Although this DN is a standard X.500/LDAP style DN, it may use a very different naming convention, which is not the usual inetOrgPerson naming (e.g. uid=joeuser,ou=People,dc=domain,dc=com). So, in order to find the user's entry when the user presents a certificate for authentication, the DS must use the attributes and values in the subjectDN. The server does this for two reasons:

-   To get the other user attributes from the user's entry
-   To compare the userCertificate in the user's entry with the one being presented for authentication

The latter is just an additional step to ensure the user's identity.

The [Using Certificate Based Authentication](http://docs.redhat.com/docs/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Managing_SSL-Using_Certificate_Based_Authentication.html) document describes the basic information about what the certmap.conf file is and how it works. NOTE: For DNComps and FilterComps, the "dc" attribute is supported in addition to the cn, ou, o, c, l, st, e, and mail attributes listed in the document. NOTE: The directory server uses "mail" instead of "e" and will automatically map uses of "e" to "mail" when "e" is specified in the subjectDN, DNComps, or FilterComps.

For example: I have a directory for my company Example, Inc.. The root suffix for my users is dc=example,dc=com, and my entry for Joe User looks like this:

    dn: uid=juser,ou=People,dc=example,dc=com    
    ...    
    objectclass: inetOrgPerson    
    ...    
    cn: Joe User    
    mail: juser@example.com    
    ...    

The "cn" and "mail" attributes are important because they will generally be used in the subjectDN of the cert. They should be indexed for equality (and usually are by default).

Next, I have a CA which has issued a certificate for Joe User with the following subjectDN:

    e=juser@example.com,cn=Joe User,dc=example,dc=com,o=Example Inc.,c=US    

As you can see, the certificate subjectDN for Joe User is very different than the entry for Joe User in the directory server. I will have to set up a mapping from the subjectDN to the directory DN. There are a few ways I could do this:

-   Make my CA issue certs with the same format for subjectDN as I use in my directory

This may be difficult or impossible depending on the CA

-   Add an attribute (e.g. certSubjectDN) to all of my user entries, the value of which is the subjectDN for that user's certificate, and use the CmapLdapAttr directive in the certmap.conf file

There is no standard LDAP attribute for this. Some schema work would be required to create a new attribute type and auxiliary object class, as well as the addition to and maintenance of every user's entry in the directory.

-   Use DNComps and FilterComps to look for matching cn and mail

The directory server can perform an internal subtree search to look for an entry matching the attributes in the subjectDN. In this case, we can construct our base DN and a search filter from the attributes in the subjectDN. Our certmap.conf might look something like this:

    certmap Example     o=Example Inc.,c=US    
    Example:DNComps     dc    
    Example:FilterComps mail,cn    
    Example:VerifyCert  on    

This would tell the server to look up certs issued by the CA for o=Example Inc.,c=US (the issuerDN) by doing a search with a base DN of dc=example,dc=com (the dc attributes from the subjectDN - it will use both of them) and using a search filter of (&(mail=juser@example.com)(cn=Joe User)). Remember that the directory uses "mail" instead of "e", so it automatically knows to grab the value of the "e" attribute in the subjectDN for the value of the "mail" attribute in the search filter. The ldapsearch command line equivalent would look something like this:

    ldapsearch ... -s sub -b dc=example,dc=com '(&(mail=juser@example.com)(cn=Joe User))' userCertificate userCertificate;binary uid    

In some cases, we may not be able to determine the search base DN from the subjectDN. For example, suppose our subjectDN were something like this:

    e=juser@example.com,cn=Joe User,o=Example Inc.,c=US    

In this case, specify DNComps, but leave the value blank. For example,

    certmap Example     o=Example Inc.,c=US    
    # DNComps has an empty value to search all naming contexts    
    Example:DNComps    
    Example:FilterComps mail,cn    
    Example:VerifyCert  on    

This will cause the server to search **all** naming contexts in the server. You should use this with caution however. One of the most important things is that your search **must** return **exactly 1** matching entry. If the search returns more than one entry, you will get a "multiple matches" error in your error log, and client cert auth will fail. Therefore, you should ensure that the attributes you use in your FilterComps have unique values. In most cases, the mail attribute will be unique.
