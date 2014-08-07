---
title: "Howto:ChainToAD"
---

# Chain to Active Directory Server
----------------------------------

Follow these steps to create a suffix (database link) chained to an Windows Active Directory suffix.

1.  Go to the Administrative console -\> Directory Server -\> Configuration tab.
2.  Expand Data. Right Click on the Data -\> New Root Suffix.
3.  Set suffix like suffix in AD. UNCHECK Create associated database automatically. Click OK.
4.  Right click on the database suffix -\> New Database Link. Enter necessary information. Click OK.
5.  Go to the Directory tab. Expand config-\>plugins-\>chaining database. Double click on the AD linked database name. Change nsProxiedAuthentication to off. Click OK.
6.  Stop the FDS server.
7.  Go to the /etc/dirsrv/slapd-<instance name>
8.  Edit dse.ldif. Look for the entry dn: cn=config,cn=chaining database,cn=plugins,cn=config. Remove all nstransmittedcontrols attributes
9.  Start server.

**Security warning:** Don't use administrator account to chain to AD. If somebody try to modify data from AD, FDS do it. But because the AD doesn't have attributes *modifiersname* and *modifytimestamp* the request fails.
