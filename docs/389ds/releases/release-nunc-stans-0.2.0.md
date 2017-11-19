---
title: "Nunc Stans 0.2.0"
---
Nunc Stans 0.2.0
----------------

The 389 Directory Server team is proud to announce nunc-stans version 0.2.0.

Source tarballs are available for download at:

[Download Nunc Stans Source]({{ site.binaries_url }}/binaries/nunc-stans-0.2.0.tar.xz)

sha256sum nunc-stans-0.2.0.tar.xz 0000632541531efe3b420137a4b071ce1281be848f562f8a1b79fba53d4ef883

Highlights in 0.2.0

- Code quality and stability improvements
- Performance improvements in all cases
- API simplification
- Test coverage and stress testing

### Installation

See [Source](../development/source.html) for information about source tarballs and SCM (git) access.

### Feedback

We are very interested in your feedback!

Please provide feedback and comments to the 389-users mailing list: <https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org>.

If you find a bug, or would like to see a new feature, file it in our Trac instance: <https://fedorahosted.org/nunc-stans/>

### Detailed Changelog since 0.1.8

- Ticket 65 - fix get set valid states
- Ticket 64 - Remove ns_job_modify
- Ticket 63 - segfault in thr_stack_create.
- Ticket 61 - Convert barriers to monitor on job.
- Ticket 55 - Remove the thread pool scaleup / down skeleton
- Ticket 62 - Remove unnecessary counters from jobs
- Ticket 60 - Fix nuncstans spec file
- Ticket 45 - Upgrade liblfds to 710
- Ticket 59 - Heap use after free in ns_job_done
- Ticket 58 - Add stress test
- Ticket 57 - Ability to disarm a persistent job from within it's callback
- Ticket 52 - ns_job_modify should not rearm
- Ticket 57 - Update the configure and autotools files
- Ticket 57 - Implement a strict state machine for nunc-stans jobs
- Ticket 54 - Move job done callback
- Ticket 51 - Job rearm should ignore if ns_persist is set
- Ticket 54 - job done callback
- Ticket 50 - Add ns_job_set_data helper
- Ticket 49 - pkgconfig missing -L option

