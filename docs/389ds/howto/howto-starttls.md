---
title: "Howto: startTLS"
---

# I am using start\_tls, but how come it only works on port 389 ?
-----------------------------------------------------------------

If you want to use ldaps, then the tcp port number 636 is in use, this is for ldap over ssl.
Un-secure or clear text communications happen on tcp port 389 by default, but there is the option to run an extended operation called startTLS, to establish a security layer before the bind operation, when using tcp port 389.
So the connection starts in clear text, and then switch to an encrypted channel using TLS, and then a bind operation happens. See RFC 4511 and 4513.

Example of log for startTLS, on port 389:

    [17/Oct/2007:14:32:52 -0700] conn=936 fd=68 slot=68 connection from 1.2.3.4 to 5.6.7.8    
    [17/Oct/2007:14:32:52 -0700] conn=936 op=0 EXT oid="1.3.6.1.4.1.1466.20037" name="startTLS"    
    [17/Oct/2007:14:32:52 -0700] conn=936 op=0 RESULT err=0 tag=120 nentries=0 etime=0    
    [17/Oct/2007:14:32:52 -0700] conn=936 SSL 256-bit AES    

The "err=0 tag=120" show a result from an extended operation.

Example of log for ssl, on port 636:

    [18/Oct/2007:08:54:53 -0700] conn=253 fd=64 slot=64 SSL connection from 1.2.3.4 to 5.6.7.8    
    [18/Oct/2007:08:54:53 -0700] conn=253 SSL 256-bit AES    
