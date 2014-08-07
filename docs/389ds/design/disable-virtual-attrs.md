---
title: "Disable Virtual Attrs"
---

# Disable Virtual Attributes

In 1.3.1 you can now turn off virtual attribute lookups, and gain a slight search performance boost.

Configuration
-------------

Under cn=config you can set 

    nsslapd-ignore-virtual-attrs: "on" or "off".

This change can be made while the server is online, and does not require a server restart.
