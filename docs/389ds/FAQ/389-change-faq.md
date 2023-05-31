---
title: "389 Change FAQ"
---

# 389 Change FAQ
----------------

In May 2009 the Fedora Directory Server project changed its name to **389**.

{% include toc.md %}

Why the name change?
====================

At the time the project was initially created early in 2005, Red Hat was going to use the **Fedora** brand as a generic brand for open source projects. There would be the *Fedora Core* operating system, *Fedora Directory Server*, *Fedora Certificate System*, and so on, for all of the layered projects (layered on top of the OS). The directory server was the first project ready to go, so it was branded with Fedora and released as the Fedora Directory Server project. Unfortunately, this idea of using Fedora as a generic brand fell out of favor soon afterwards. Fedora Core was changed back to simply Fedora for the OS. Other layered projects acquired their own unique names - freeIPA, DogTag, etc. The directory server already had momentum and mind share, so the original name stuck for the time being.

One of the things that has hurt the growth and acceptance of the project in the open source community is the name 'Fedora'. The name implies that it is "The Directory Server of Fedora". This is not true. In addition, anything associated with 'Fedora' and 'Red Hat' has a negative connotation in some communities, and that has caused some people to stay away from porting or running the directory server on other platforms. We recognize the need to have better support on Debian and its derivatives, Suse and its derivatives, other distros, and other operating systems (*BSD, Solaris, etc.). Having a distro and vendor neutral name will help in that regard.

Finally, the time is right, the stars have aligned, _insert your favorite metaphor here_, and we're going forward with the name change.

Does this mean the project will change?
=======================================

No. The project will remain the same. Nothing has changed except the name. We're still committed to improving the code, new features, etc. We will continue to be active in email and IRC. Hopefully we will see some changes for the better, that is, the expansion of the project to include more distros, users, and developers.

Why "389"?
==========

We spent a lot of time trying to come up with something suitable. We tried words like 'syzygy' and 'uroboros', but as usual in these cases, any name we came up with was met with a considerable amount of ambivalence. Made up words like 'frabbitz' were just as bad. Various combinations of 'freeX' and 'openX' didn't work either. In short, it was a long and agonizing process. Finally, we just thought that "389" was short, simple, to the point, didn't infringe on any current or prior use, and "389" is synonymous with LDAP.

What's up with 389.org? Why port389.org and 389tcp.org?
=======================================================

389.org is owned by a squatter who has refused all contact with a simple automated reply of "not for sale". We are still working on this, but if you can lend a hand, we would be most appreciative.

What do I call the project/server/package/etc.?
===============================================

-   project - "389"
-   directory server - "389 Directory Server"
-   other sub projects - "389 Admin Server", "389 Console", etc.
-   packages - 389-ds-base, 389-admin, 389-console, etc.

What else has changed?
======================

This site - port389.org and 389tcp.org now point to directory.fedoraproject.org

Mailing lists - 389-users@lists.fedoraproject.org - email sent to the old fedora-directory lists @redhat.com will be forwarded (for the time being)

IRC - there is a new channel #389
