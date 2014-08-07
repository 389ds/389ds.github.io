---
title: "Roadmap"
---

# Roadmap
---------

This page contains the high-level roadmap for the 389 Directory Server project. Our development work is defined in the milestones in our [Trac instance](https://fedorahosted.org/389/). For complete and current details on what is going into a particular release, you should look at the Trac instance.

The tickets in a milestone are generally worked on in priority order. In general, we plan to address everything that is defined as **major** or higher priority. Some tickets that have a **low** or **trivial** priority will likely end up being pushed to the next milestone if they are not completed before out targeted release date. These tickets are a good place to look if you want to help contribute, as a number of them are usually easy issues to work on.

Tickets in the **FUTURE** milestone are things that have not been planned for any specific release. We usually scan through these when planning a release to see if they make sense to pull in. There are quite a few tickets that are not things that we plan to implement ourselves, but might make sense for someone to contribute. If you are interested in working on one of the tickets in the **FUTURE** milestone, please contact us on the development [mailing list](../mailing-lists.html), or via [IRC](../mailing-lists.html).

Current Development Plans
-------------------------

Development is currently focused on the **1.3.1** release of 389 Directory Server. The targeted release date is the beginning of April, 2013.

The focus items and features for this release are:

-   Performance and scalability improvements
-   SASL mapping priority and fallback
-   Configurable allowed SASL mechanisms
-   Improved logconv.pl memory usage
-   Improved instance scripts
    -   Centralized location
    -   SASL, LDAPI, LDAPS, and startTLS support
-   Password management by non Directory Manager users
    -   Allows pre-hashed passwords to be imported by admin users
    -   Allows forcing password changes by admin users

The full list of tickets that we plan to address can be viewed in our Trac instance:

-   [1.3.1 Tickets](https://fedorahosted.org/389/report/18)

Future Plans
------------

Version **1.3.2** of 389 Directory Server is currently in planning.

The focus areas/features that are currently being proposed are:

-   Performance and scalability improvements
    -   This continues the performance work that is being done in version 1.3.1.
-   Schema handing improvements
    -   Improved parser (use OpenLDAP client library parser)
    -   Multi-master custom schema replication (current versions are single-master)
    -   Store custom schema in separate custom files instead of 99user.ldif
-   LDAPI access control support
-   Store replication conflict and tombstone entries in a separate tree

The full list of tickets proposed for version 1.3.2 are available in our Trac instance:

-   [1.3.2 Tickets](https://fedorahosted.org/389/report/19)

