---
title: "Nunc Stans 0.2.1"
---
Nunc Stans 0.2.1
----------------

The 389 Directory Server team is proud to announce nunc-stans version 0.2.1.

This is an important release, as it corrects a defect found in 0.2.0. The defect prevents servers shutting down cleanly or correctly, and may lead to data corruption in some cases. All users of Nunc Stans should upgrade to 0.2.1.

Source tarballs are available for download at:

[Download Nunc Stans Source]({{ site.baseurl }}/binaries/nunc-stans-0.2.1.tar.xz)

sha256sum nunc-stans-0.2.1.tar.xz ee87a1e090e2b06616f3626c14c465226fadcf2d0d42bd4a178771b4a5ecf972

Highlights in 0.2.1

- Important fix for signal registration
- Remove autotools files.

### Installation

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/nunc-stans/>

### Detailed Changelog since 0.2.0

- Ticket 69 - Remove configure outputs
- Ticket 68 - Missing event registration
- Ticket 66 - Nunc-stans requires c99
