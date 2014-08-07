---
title: "Howto:CopyACIs"
---

# How to copy ACIs from one server to another
-------------------------------------------

This assumes your target/destination server has the same structure - same suffix, same container entries (i.e. ou=people), etc.

Get the acis from the old server

    ldapsearch -xLLL -h old.server -D "cn=directory manager" -w password -b "dc=your,dc=suffix" '(aci=*)' aci > acis.ldif

Edit acis.ldif

    perl -p0e 's/\n //g' acis.ldif | awk '/^dn:/ {print; print "changetype: modify"; print "replace: aci"; next} ; {print}' > newacis.ldif

Modify your new server

    ldapmodify -x -h new.server -D "cn=directory manager" -w password -f newacis.ldif
