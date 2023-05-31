---
title: "Package Release Procedure"
---

# Package Release Procedure
----------------------------

This page describes the package release procedure (e.g. RPMs for Fedora/EPEL). For the source code release and versioning procedure see [Release\_Procedure](release-procedure.html)

Fedora/EPEL
===========

Prerequisites
-------------

### Read this Guide

[How To Be A Fedora/EPEL Package Maintainer](http://fedoraproject.org/wiki/Join_the_package_collection_maintainers) - this is a good step-by-step guide which tells you which accounts you need and which packages you need to install. It also has other useful information about Fedora systems, RPM, yum, etc.

### Set up Accounts

-   A bugzilla account at <http://bugzilla.redhat.com>
-   A FAS account at <https://admin.fedoraproject.org/accounts/user/new>
    -   You will need to create an ssh key pair and upload your public key
    -   You will need your ssh key, and FAS account password, for subsequent packaging steps
-   Access - an existing 389 maintainer will need to grant you access to be able to commit/push changes
    -   Requires a FAS account and possibly addition to the packagers group in FAS (see below)
    -   <https://admin.fedoraproject.org/pkgdb/>
    -   Search: PACKAGES - Search for the package (e.g. 389-ds-base)
    -   For each Collection, request watchbugzilla, watchcommits, and commit access
    -   Find a 389 maintainer and bug them until they approve your access

### Become a Package Maintainer

You will need a FAS account before you can be added to the package maintainers group. Unless you are adding a new package, you will want to be a Co-Maintainer [How to become a Co-Maintainer](http://fedoraproject.org/wiki/How_to_get_sponsored_into_the_packager_group#Become_a_co-maintainer). You will have to find someone who is a Sponsor to add you to the packager group in FAS [How to sponsor a new contributor](http://fedoraproject.org/wiki/How_to_sponsor_a_new_contributor).

### Install Software

-   If you develop on EL (RHEL, CentOS, etc.) - EPEL - the EPEL repo package - [Setup EPEL repo](https://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F)
-   run 'yum install fedora-packager'
    -   this installs the all-important fedpkg, bodhi, koji, git, etc.
-   run 'fedora-packager-setup'
    -   This sets up your system to communicate with various Fedora systems
-   [Useful information for using git for Fedora packaging](http://fedoraproject.org/wiki/Using_Fedora_GIT)

### Get the Packages

-   You will likely work with multiple packages, so create a parent directory for your fedora/epel packages:

        mkdir ~/fedora-pkgs

-   fedpkg clone *pkgname* e.g.

        fedpkg clone 389-ds-base

This will create a subdirectory called *pkgname*. fedpkg uses git under the covers, and you can mostly use regular git commands. One notable exception is *git checkout* - use *fedpkg switch-branch* instead.

<a name="add-files"></a>Edit/Add Files
--------------

Usually changes will apply to multiple branches (e.g. a new release on master/F18/F17). It's best to work in the *master* branch, then merge or cherry-pick your changes to other branches.

-   fedpkg switch-branch master \<- make sure you are on master branch
-   edit the 389-ds-base\*.sh & 389-ds-base.spec file and change the version
-   the file *packagename*-git-local.sh can be used to generate the official source tarball - see [Create\_the\_source\_tarball](release-procedure.html#create-tarball)
    -   for example:
        -   cd 389/ds.git
        -   sh -x /path/to/fedora-pkgs/389-ds-base/389-ds-base-git-local.sh /path/to/put/source/tarball/
-   If you changed the Version: in the spec file:
    -   make sure the “Release” field is set back to 1 - Release: %{?relprefix}1%{?prerel}%{?dist}
-   in the %changelog section - add the header (copy/paste/edit a previous one)
    -   you can generate a changelog - [Release\_Procedure\#Generate\_a\_Changelog](release-procedure.html#gen-changelog)
    -   if you generate the changelog from git
        -   Remove the hash prefix value for all bugzilla and track bugs
        -   Leave the hash for coverity/misc updates
    -   for the changelog information, use the changelog that was generated from the source release [Release\_Procedure\#Generate\_a\_Changelog]../development/release-procedure.html#gen-changelog) or generate a new one
-   verify your changes - fedpkg verrel - should print the correct version and release
-   update the source - fedpkg new-sources /path/to/389-ds-base-VERSION.tar.bz2 - see [Release\_Procedure](release-procedure.html) about generating a source tarball
    -   this will do a 'git add sources .gitignore' so you will see them staged in git status
-   git commit -a -F changelogfile
    -   you can also generate a changelog file from the last change in the %changelog section of the spec with fedpkg clog - this will create a file called *clog*
-   For each branch that needs to be updated:
    -   fedpkg switch-branch fX \# e.g. f18
    -   git merge *next highest branch* - for example, if you are currently on branch f17, then merge with f18
    -   if the merge fails with conflicts, or is not a Fast Forward, then
        -   git reset --hard HEAD\^
        -   git cherry-pick -x *next highest branch*
    -   If the cherry-pick was not clean
        -   git status - look for Both Modified - edit the files that are in conflict - usually just the .spec file
        -   git add each file that was fixed
        -   git status - make sure everything looks ok
        -   git commit -c *next highest branch*
-   Push the changes
    -   git push --dry-run - make sure there are no conflicts or un-committed files
    -   git push - will push all branches

Build
-----

For each branch:

-   fedpkg switch-branch *branch*
-   fedpkg build --nowait

You will receive email notification when the build is complete - if it fails, go back to Edit/Add Files - you will need to at least bump the Revision number in the .spec file, commit/cherry-pick/push, then Build again.

EPEL 6 - 389-ds-base
--------------------

389-ds-base is not in EPEL6 or later because it is included in RHEL, and EPEL policy forbids it. We still provide builds for EPEL though, via the [Fedorapeople Repos](https://fedoraproject.org/wiki/Fedorapeople_Repos). These packages do **not** follow the regular fedpkg build/update procedure. Instead, it is entirely manual.

-   use mock to build - yum install mock - usually included with fedora-packager
-   the EL6 spec file is in the el6 branch in the fedora-pkg 389-ds-base repo, just like the spec files for the other branches/releases
-   fedpkg switch-branch el6
-   edit or git merge or git cherry-pick from the source branch and git commit the changes
-   fedpkg srpm - make a local .src.rpm file
-   mock -r epel-6-x86\_64 pkg-ver.src.rpm
-   mock -r epel-6-i386 pkg-ver.src.rpm
-   the result rpm files are in /var/lib/mock/epel-6-x86\_64 i386
-   following the instructions at [Fedorapeople Repos](https://fedoraproject.org/wiki/Fedorapeople_Repos) set up and push your packages
-   I suggest setting up separate Testing and Stable repositories as in Fedora

Submit the Build to Testing
---------------------------

For each branch:

-   fedpkg switch-branch *branch*
-   fedpkg update
    -   type=bugfix
    -   request=testing
    -   bugs= <nothing if there are no “Fedora” bugs included - e.g. bugzilla.redhat.com Fedora 389-ds-base>
    -   autokarma=True
    -   stable\_karma=1
    -   unstable\_karma=-1

Note: fedpkg update will start up *vi* editing a form. You can use this form for each branch. Instead of saving and exiting, first just save it, then save it under a name like *update.save*. When you do the next update in the next branch, delete the contents of the buffer, then load in your saved file, then edit the release and version.

After the update has been pushed, you will receive an email notifications from the koji/bodhi workflow, and when the package has been pushed to the Testing repositories.

Push the Update to Stable
-------------------------

You can monitor the state of the update in bodhi - [Fedora Update System](https://admin.fedoraproject.org/updates). There are a couple of ways to push the update to the Stable repositories.

-   Auto-Push - once an update receives enough positive karma, it will be auto-pushed - if it receives enough negative karma, it will be removed
    -   Only approved testers may give karma
    -   Login to bodhi - go to the update - click on the Works For Me button to give positive karma
    -   Maintainers in general, and the person who pushed the update in particular, should not give positive karma
-   Aging - once the build reaches a certain age, it will be eligible to push to Stable
    -   You will receive email notification when the build has reached the Stable threshold
    -   Login to bodhi - go to the update - click on the Push to Stable button/link

Update Source Repo
------------------

If you did not already push the VERSION.sh commit and the version tag as in [Release\_Procedure](release-procedure.html#gen-changelog), do so now. Once the build is out in the wild, you have no choice but to release another version from scratch.

Example fedpkg/git workflow
---------------------------

Here is a very simple sequence of operations:

    fedpkg clone 389-ds-base
    cd 389-ds-base
    fedpkg switch-branch master
    vi 389* # edit Version, Release, add %changelog
    fedpkg new-source /path/to/389-ds-base-VERSION.tar.bz2
    fedpkg clog
    fedpkg verrel
    git commit -a -F clog
    fedpkg switch-branch f18
    git cherry-pick -x master
    fedpkg switch-branch f17
    git cherry-pick -x f18
    git push --dry-run
    git push
    fedpkg switch-branch master
    fedpkg build --nowait
    fedpkg switch-branch f18
    fedpkg build --nowait
    fedpkg switch-branch f17
    fedpkg build --nowait

    # wait for the builds to complete - you will receive email notification

    fedpkg switch-branch f18
    fedpkg update
    fedpkg switch-branch f17
    fedpkg update

