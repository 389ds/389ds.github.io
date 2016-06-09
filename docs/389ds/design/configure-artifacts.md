---
title: "Configure Artfiacts Discussion"
---

# Configure Artifact Discussion

Overview
========

It was proposed that we remove a set of files from our git repository.

    autom4te.cache
    m4/libtool.m4
    m4/ltoptions.m4
    m4/ltsugar.m4
    m4/ltversion.m4
    m4/lt~obsolete.m4
    Makefile.in
    aclocal.m4
    ar-lib
    compile
    config.guess
    config.h.in
    config.h.in~
    config.sub
    configure
    depcomp
    install-sh
    ltmain.sh
    missing
    .deps/
    Makefile
    config.h
    config.log
    config.status
    libtool
    stamp-h1
    .libs
    .dirstamp


Case for retenion of configure artifacts
========================================

Portability
------------

We have a set of configure and other input files that we know work. These can be used on other platforms (Solaris, etc) without need to have gnu autotools installed on the target. This increases portability to these systems

-- Counter point: 

* Most platforms have GNU autotools avaliable, and those that don't we likely don't support actively anymore. (Or anyone even consuming our software on those platforms)

Easier for developers
---------------------

When we change a value in the autotool related scripts we commit them. This means other developers in the team don't have to run autoreconf to consume the changes.

-- Counter point:

* We should be running autoreconf regularly on our repo to make sure that we test our software on a variety of distros, autotool versions, and we find issues in the usage of the tool.
* Running autoreconf avoids the case where a change to .m4 occurs, and the configure artifacts are not commited. This creates confusion.

Case for removal of configure artifacts
=======================================

Developer autotools versions cause large diffs
------------------------------------------------

On each developers machine we have a variety of autotools versions. I know the distros are used at a minimum within the team:

* F21
* F22
* F23
* EL7

As a result there is at least 4 versions of autotools just there. Each change or commit by these way upgrade or downgrade the autotools version stored in our repository.

At the moment this on my system generates a diff of "4 files changed, 317 insertions(+), 247 deletions(-)". I have seen this number both smaller and larger.

On each of these platforms we (likely) have to run autoreconf --force anyway. This can cause back-and-forth if we end up commiting these autoconf artifacts to git.


-- Counter point:

* Don't be lazy. Just ignore the files during a commit, and do a git reset when you change branches.

Distros run autoreconf as part of their build process
-----------------------------------------------------

Other distros are likely running autoreconf as part of their build process, so shipping pre-made files is redundant as these will be re-created anyway. We are maintaining these files in git for no one to consume them.

-- Counter point:

* The git checked in files aren't hurting anyone, and they aid portability to distros that are not running autoreconf.

Author
------

<wibrown@redhat.com>


