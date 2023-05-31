---
title: "Release Procedure"
---

# Release Procedure
-------------------

This page describes the source release procedure, for creating the official source tarballs for [Sources](source.html). For the package release procedure (e.g. for Fedora/EPEL RPMs), see [Package Release Procedure](package-release-procedure.html)

{% include toc.md %}

Pre-Requisites
--------------

-   git - yum install git
    -   [Using git with 389](git-rules.html)

Set up Accounts
---------------

-   A FAS account at <https://admin.fedoraproject.org/accounts/user/new>
    -   You will need to create an ssh key pair and upload your public key
    -   You will need your ssh key in order to push updates to the 389 git repo
    -   You will need a Fedora cert (\~/.fedora.cert) - when you get your FAS account, it should prompt you to get a cert
-   git push access - you will need to be a member of the git389 group in FAS
    -   Requires a FAS account
    -   [<https://admin.fedoraproject.org/accounts/group/view/git389>](https://admin.fedoraproject.org/accounts/group/view/git389)
    -   Request access, then bug a 389 developer to add you

Get the Source
--------------

-   git clone <ssh://git.fedorahosted.org/git/389/ds.git>
    -   or admin.git or adminutil.git or ... whatever the package is
    -   You will need your ssh key to do this - you can use git: or https: but you will not be able to push
    -   You can edit your .git/config later to change git: or https: to ssh:
-   cd ds (or admin or whatever)
-   git checkout *branch* e.g. git checkout 389-ds-base-1.2.11
    -   A 389-ds-base release will almost always be done off of a branch
    -   Other packages (admin, adminutil, etc.) usually do not use branches, use master instead
    -   If you do not yet have a branch:
        -   Use git log etc. to find your branch point
        -   git checkout -b *new branch name* *commithashofbranchpoint*
        -   git push origin *new branch name*

Bump the Version and Tag the Source
-----------------------------------

-   Use the git work flow specified at [GIT Rules](git-rules.html) to make sure you apply the version changes correctly - merges should be fast forward only - no Recursive merges or merge commits.

-   git checkout *branch*
    -   389-ds-base (ds) - all work should be done on the release branch (see above)
    -   other projects - just use master branch

### Official Release

-   389-ds-base, 389-admin - edit VERSION.sh - Change the version number to remove any pre-release strings, and bump the VERSION\_MAINT. For example, if the version were specified as 1.2.3.rc2 in VERSION.sh:

        VERSION.sh:
        ...
        VERSION_MAJOR=1
        VERSION_MINOR=2
        VERSION_MAINT=3
        VERSION_PREREL=rc2

    just comment out the VERSION\_PREREL and increase VERSION\_MAINT:

        ...
        VERSION_MAJOR=1
        VERSION_MINOR=2
        VERSION_MAINT=3.1
        #VERSION_PREREL=rc2

-   adminutil, dsgw, etc. - edit configure.ac - change the version in AC\_INIT - run autogen.sh

### Pre-Release (alpha, rc, other pre-rel)

For 389-ds-base (ds), the active tree (master branch) should **always** be in the pre-release state - anyone pulling the tree using the tag HEAD or git fetch/pull should always see a pre-release tree. The only way to get an officially released source code tree is to pull from an official release tag. Other branches will be in the pre-release state until an official release.

To move to the next pre-release:

-   Change the pre-release field
    -   if moving from an official release to a pre-release, change the MAINT number to the next one, and change the pre-release number to **a1**
    -   if moving to the next alpha or release candidate, just change the number after the **a** e.g. a2 -\> a3
    -   if moving to a release candidate, change the **aN** to **rc1** e.g. a4 -\> rc1

            VERSION.sh:
            VERSION_PREREL=a1

        change to

            VERSION_PREREL=a2

Commit the Version Changes
--------------------------

-   commit the changes to the SCM
    -   389-ds-base, 389-admin - git commit -m "bump version to 1.2.3.1" VERSION.sh
    -   adminutil, dsgw, etc. - git commit -a -m "bump version to 1.2.3.1"

Tag the Release
---------------

-   tag the release
    -   git rebase, checkout master, and merge if necessary - see [GIT Rules](git-rules.html)
    -   389-ds-base - apply the tag on the main branch (e.g. 389-ds-base-1.2.11) you are working on, not on a private side branch

            git checkout 389-ds-base-1.2.11

    -   389 other projects - just use master

            git tag 389-ds-base-1.2.3.1

Note that with git a tag is just an "alias" for a commit - you can easily view the commit associated with the tag, including the timestamp, so there is no need to create timestamped tags.

Push the Changes and Tag
------------------------

NOTE: If you are doing this in conjunction with a package release, you should review [Package Release Procedure](package-release-procedure.html) before you push your commits and tags - once you push a tag, you cannot "unpush" the tag, so you should make sure the package builds properly in all of your operating systems first, in case you need to change the source in order to fix the build problems. Otherwise, you will have to bump the version and go through the entire process again.

-   verify that git push is ok

        git push --dry-run origin

-   push the version change commit and the tag to the upstream repo

        git push origin 389-ds-base-1.2.3
        git push origin refs/tags/389-ds-base-1.2.3.1

    NOTE: do not use **git push --tags** because you might inadvertently push tags you did not intend - when pushing tags to the official git repo, always use the explicit tag reference

-   check the upstream repo to verify your commit and tag - you can just web browse to <http://git.fedorahosted.org/git/?p=389/ds.git> or admin.git or whatever

<a name="create-tarball"></a>

Create the source tarball
-------------------------

Start from a TAG (PACKAGE-VERSION) which was created using the above tagging procedure.

-   git checkout *branchname* --> the branch you are going to create the release from
-   git checkout master --> for 389-admin, adminutil, etc.
-   git pull origin --> get the latest changes and tags
-   git archive --prefix=TAG/ TAG \| bzip2 \> /path/to/TAG.tar.bz2
    -   TAG is in the form PACKAGENAME-VERSION e.g. 389-ds-base-1.2.11.1 or 389-admin-1.1.40
-   if you are doing a package release, some packages have a script called *packagename*-git-local.sh - use this script to generate the source tarball
    -   see [Package Release Procedure](package-release-procedure.html#add-files)

<a name="gen-changelog"></a>

Generate a Changelog
--------------------

The changelog is useful for updating the [Release Notes](../releases/release-notes.html) and for the %changelog in the [Package Release Procedure](package-release-procedure.html#add-files ).

-   git log --oneline PREVIOUSTAG.. \> /path/to/clog
    -   the previous tag is the last tag before the current one
    -   for example, if you are doing the 389-ds-base-1.2.11.12 release, use

-   git tag --oneline 389-ds-base-1.2.11.11.. > /path/to/clog`

    to list all of the changes since the last tagged release

Push the Source Tarball to [Source](source.html)
------------------------------------------------------

This requires getting in touch with the owner of port389.et.redhat.com and requesting scp/ssh access.

Once the source tarball is available from [here]({{ site.binaries_url }}/binaries/), update the [Source](source.html) page with the URL, tag, and sha1sum of the source tarball.

Update [Release Notes](../releases/release-notes.html)
-------------------------------------------------

Note: If you are doing a package release [Package Release Procedure](package-release-procedure.html) you may want to wait until the packages have been pushed to Testing.

You can usually just copy/paste/edit a previous release notes, updating the date, version, new features, bugs, any notes, etc.

Update the [Main Page](/)
---------------------------------------------

Add a note about the release to the [Main Page](/) - can usually just copy/paste the previous one, and edit the date/version/text.

Update the [History](../FAQ/history.html) and/or [Roadmap](../FAQ/roadmap.html)
-----------------------------------------------------------------------------

This is similar to the [Release_Notes](../releases/release-notes.html) - basically a list of features with a short description and a link to the wiki page with more details. If this is a work in progress it might be more appropriate for [Roadmap](../FAQ/roadmap.html). At some point in the release cycle, it makes sense to move a release from [Roadmap](../FAQ/roadmap.html) to [History](../history.html).

Update the \#389 IRC Banner
---------------------------

Let #389 users know about the new release.

    /msg nickserv identify yourpassword
    /msg chanserv op #389 youruserid

Then change the /topic of the \#389 channel

E-Mail 389 Mail Lists
---------------------

Send email to 389-users@lists.fedoraproject.org and 389-announce@lists.fedoraproject.org

Advertise
---------

Update the wikipedia page, freshmeat.net, ohloh.net, and any other sites that track new software releases.

Versioning
==========

Some background on version numbering is available here - <http://en.wikipedia.org/wiki/Software_versioning>.

Naming
------

A full version name will be *PACKAGENAME* *-* *VERSIONNUMBER* e.g. 389-ds-base-1.2.11.1. The PACKAGENAME part will be the name typically given to the binary package. This name will also be used in the source. For packages that use autoconf for building, this will be the PACKAGE\_TARNAME setting. The goal is that the full version name and number used in the source tarball name is the same as the SCM tag name of the tag used to produce that source tarball, and is the same as the name of the binary package. For autoconf packages, this also means the same source tarball name as produced by a *make dist*.

    NAME=<name of package>
    VERSION=<version number>
    SRCNAME=$NAME-$VERSION
    TAG=$SRCNAME
    git tag $TAG
    git archive --prefix=$TAG/ $TAG | bzip2 > $SRCNAME.tar.bz2
    make dist -> $SRCNAME.tar.bz2
    rpmbuild $NAME.spec -> $NAME-$VERSION.<dist>.<platform>.rpm # for RPM platforms

There are a couple of important exceptions to this:

-   The DS base and admin packages use an autoconf package name of *dirsrv* and *dirsrv-admin* - this is the name used to name files and directory paths (e.g. */etc/dirsrv*). This is not the same as the name of the source tarballs and binary packages.
-   For RPMs, the RPM version number cannot be the same as the source version number for *pre-release* builds only, due to the way RPM calculates package dependencies and upgrades - see below

Source Version
--------------

The source version is the version number/string assigned to the source code and the SCM tag. It is comprised of several parts. In general, the version numbers look like this:

    MAJOR.MINOR.MAINTENANCE.PRE-RELEASE

or

    MAJOR.MINOR.MAINTENANCE.PATCH

examples:

    1.2.3 # an official release
    1.2.3.a1 # alpha 1 pre-release of 1.2.3
    1.2.3.a4.git283abc3 # alpha 4 pre-release of 1.2.3 from a git commit with short commit hash 283abc3
    1.2.3.rc1 # release candidate 1 of 1.2.3
    1.2.3.1 # patch release 1 for 1.2.3

The PRE-RELEASE part (explained below) is optional, and indicates software that has not been officially released, in alpha, in testing, or a release candidate. The fields in the version number are explained below:

-   MAJOR - an integer - the major version - this only changes for very large or incompatible changes in the code
-   MINOR - an integer - the minor version - this changes when substantial changes are in the code
-   MAINTENANCE - an integer - this can change when there are small but non-trivial changes to the code (new functionality, bug fixes, errata)
-   PRE-RELEASE - (optional) - a string
    -   **a** - indicates an alpha release - should be followed by an integer indicating which alpha release this is e.g. **a1**
    -   **rc** - indicates a release candidate - should be followed by an integer indicating which release candidate this is e.g. **rc1**
    -   The first alpha release is a1, then a2, etc. The first rc release is rc1, then rc2, etc. - just bump the number by 1 each time
    -   additional text may appear after the **aN** or **rcN** - for example, if you want to mark the build with a git commit hash:
        -   1.2.3.a3.git23ab3512
        -   Note that if the source is tagged often, the VERSION.PRE-RELEASE will already correspond exactly to an SCM tag, so using a git commit hash like this is probably not necessary
-   PATCH - an integer - indicates a patch to a MAJOR.MINOR.MAINTENANCE release

Tag Version
-----------

The version number part of a tag name will be exactly the same as the Source Version described above. This will allow us to go from a source tarball name to a git tag (and therefore a complete git tree). In git, tags are cheap and don't have the restrictions that plague CVS tagging, so we should use tags as much as possible.

Package Version
---------------

In general, we follow the Fedora Packaging Guidelines - <https://fedoraproject.org/wiki/Packaging:NamingGuidelines> - However, this means that the source/tag will not be identical to the package name-version-release. This will involve some complication in the RPM spec file for pre-release builds and snapshot builds. Fedora uses VERSION **-** RELEASE (e.g. 1.2.3-1) for the full version numbering and package naming. The VERSION is the dotted triplet of integers corresponding to the MAJOR.MINOR.MAINTENANCE. For official, blessed releases, the RELEASE is just a single integer that increments each time the spec is changed. For pre-releases, the RELEASE will begin with a **0.**, followed by the regular monotonically increasing release number, followed by the PRE-RELEASE part of the source/tag version. Here are some examples.

|Source|Spec V-R|Comment|
|------|--------|-------|
|1.2.3.a1|1.2.3-0.1.a1|first alpha pre-release of 1.2.3|
|1.2.3.a2|1.2.3-0.2.a2|second alpha pre-release of 1.2.3|
|1.2.3.a3.git83fad321|1.2.3-0.3.a3.git83fad321|third alpha pre-release with git commit hash appended|
|1.2.3.rc1|1.2.3-0.4.rc1|first release candidate pre-release|
|1.2.3.rc2|1.2.3-0.5.rc2|second release candidate pre-release|
|1.2.3.0|1.2.3.0-1|first official 1.2.3 release|
|1.2.3.0|1.2.3.0-2|1.2.3 rebuild - release number is bumped (e.g. spec file changed but not source)|
|1.2.3.1|1.2.3.1-1|1.2.3.1 patch release - release number is reset to 1 (e.g. spec file changed but not source)|

Notice that for pre-releases, the release field changes each time, and does not necessarily correspond to the number associated with the **a** or the **rc**. For example, a1 -\> 0.1, a2 -\> 0.2, a3 -\> 0.3, but rc1 -\> 0.4. The RELEASE field behaves for pre-releases exactly the same way it behaves for regular releases, except that for pre-releases, it begins with a **0.**.

This means, however, that the spec file cannot use the Version: field for both the package version and the source version. The spec file will need some special handling to account for this and for pre-releases.

    # since this is a pre-release, define the prerel field - comment out for official release
    %define prerel .a4
    # also need the relprefix field for a pre-release
    %ifdef prerel
    %define relprefix 0.
    %endif
    ...
    Name: 389-ds-base
    Version: 1.2.3 # note - same as source version
    # if this is an official release, prerel will be commented out and both prerel
    # and relprefix will therefore not be defined, so %{?relprefix} and %{?prerel}
    # will expand to nothing giving us a V-R of 1.2.3-1
    # if prerel and relprefix are defined, we will have a V-R like 1.2.3-0.4.rc1
    # if version or prerel changes, reset to %{?relprefix}1%{?prerel}%{?dist}
    Release: %{?relprefix}1%{prerel}%{?dist}
    ...
    Source0: http://port389.org/source/%{srcname}-%{version}%{?prerel}.tar.bz2
    ...
    %prep
    %setup -q -n %{srcname}-%{version}%{prerel}

Doing the numbering this way preserves RPMs ability to do upgrades, since X.Y.Z-1 \> X.Y.Z-0.1.something

Changing the Version
--------------------

Large packages that will have many version changes, such as the core directory server and admin server, will use a file called VERSION.sh that holds the version and other fields used to name the package. This will allow us to change the version without having to edit configure.ac, run autogen.sh, etc. Packages that don't change very often will just use the version field of AC\_INIT in configure.ac, and will have to perform autogen.sh. This shouldn't be a big deal for packages that do not change very often.

