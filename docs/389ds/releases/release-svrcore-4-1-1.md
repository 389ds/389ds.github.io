---
title: "Svrcore 4.1.1"
---
Svrcore 4.1.1
-------------

The 389 Directory Server team is proud to announce svrcore version 4.1.1.

Source tarballs are available for download at [Download 389-ds-base Source]({{ site.binaries_url }}/binaries/svrcore-4.1.1.tar.bz2).

Fedora packages are avaliable for Fedora 24 and Rawhide repositories.

### Highlights in 4.1.1

- Code quality and stability improvements
- Improved rpm tooling

### Installation

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org> as well as <https://bodhi.fedoraproject.org/updates/svrcore-4.1.1-1.fc24>.

If you find a bug, or would like to see a new feature, file it in our Pagure instance: <https://pagure.io/svrcore/>

### Initial Changelog

William Brown (8):
      Ticket 5 - Integrate asan support for code quality checking
      Ticket 10 - Use after free
      Ticket 7 - Incorrect result check
      Ticket 6 - Resource leak in systemd ask pass
      Ticket 8 - Coverity compiler warnings
      Ticket 9 - Coverity deadcode
      Ticket 12 - update spec to match fedora 4.1.0
      Release 4.1.1 of svrcore

