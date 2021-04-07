---
title: "Fedora Release Process"
---

# Fedora Release Process
------------------------

{% include toc.md %}


### Prerequisites

You will need a FAS account at <https://admin.fedoraproject.org/accounts/user/new>

-   you will need to create an ssh key pair and upload your public key
-   you will need your ssh key in order to push updates to the 389 git repo
-   you will need a Fedora cert (\~/.fedora.cert) - when you get your FAS account, it should prompt you to get a cert

git push access - you will need to be a member of the git389 group in FAS

-   Requires a FAS account
-   <https://admin.fedoraproject.org/accounts/group/view/git389>
-   Request access, then bug a 389 developer to add you

**DS** = the 389 source code SCM - git clone git@github.com:389ds/389-ds-base.git

**Fedora** = the 389-ds-base dist-git repo which contains the specfile - (use **fedpkg clone 389-ds-base**)


### Do the Upstream Release

**DS** - checkout the source, add the fixes, set the version, tag it, and archive it
--------------------------------------------------------------------------------

-   **mkdir /home/source/ds389; cd /home/source/ds389**

-   **git clone git@github.com:389ds/389-ds-base.git**

-   **cd 389-ds-base**

-   **git checkout 389-ds-base-x.x.x**

-   Commit any fixes that have not yet been applied

-   Do a **git log** to make sure all the commits are done!

-   Update **VERSION.sh** and set the new version string

-   **git commit -a -m “**Bump version to \<new version\>**"**

-   All commits must be done before **git tag**! Otherwise you might need to use **git tag -f \$TAG**

-   Generate the source tarball, and changelog file (used for updating the specfile's changelog and the wiki release notes)

    -   **TAG=389-ds-base-1.3.9.1** ; **git tag \$TAG** ; **git archive -\\\-prefix=\$TAG/ \$TAG \| bzip2 \> \$TAG.tar.bz2 ; git log -\\\-oneline 389-ds-base-1.3.9.0.. \> /tmp/cl-info**

    -   **F32** : **TAG=389-ds-base-1.4.3.14 ; git tag \$TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log -\\\-oneline 389-ds-base-1.4.3.13.. \> /tmp/cl-info**
    -   **F33** : **TAG=389-ds-base-1.4.4.14 ; git tag \$TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log -\\\-oneline 389-ds-base-1.4.4.13.. \> /tmp/cl-info**
    -   **F34** : **TAG=389-ds-base-2.0.4 ; git tag \$TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log -\\\-oneline 389-ds-base-2.0.3.. \> /tmp/cl-info**

-   Edit the **/tmp/cl-info** file. Remove the hash prefix value for all bugzilla and trac bugs. Leave the hash for coverity/misc updates.


**Fedora** - Dist-Git - Clone it, and update the specfile
--------------------------------------------

-   **mkdir /fedora; cd /fedora**

-   **fedpkg clone 389-ds-base**

-   **cd 389-ds-base**

-   First copy the contents of the edited **cl-info** file

-   Edit the spec file **/fedora/389-ds-base/389-ds-base.spec**

-   Change the version in the spec file.  Make sure the **release** field is set back to **1: %{?relprefix}1%{?prerel}%{?dist}**

-   Goto the **changelog** section

-   Add the header line:

       * Tue Jul 17 2018 Mark Reynolds \<mreynolds@redhat.com\> - 1.4.1.6-1

-   Then copy in the contents of **cl-info** underneath the header

-   kinit *id*@FEDORAPROJECT.ORG

-   **fedpkg verrel** - Verify changes to spec file is producing the correct version.

-   **fedpkg new-sources /home/source/ds389/389-ds-base-1.4.1.6.tar.bz2 /home/source/ds389/jemalloc-5.1.0.tar.bz2**  - tar ball created by git archive cmd from above, and always include **jemalloc**. Another option is just **uploading** the recent tarball **fedpkg upload /home/source/ds389/389-ds-base-1.4.1.6.tar.bz2**

-   **git status** - Should show the "sources" and ".gitignore" are staged

-   remove from **sources** file the useless tarballs

-   **fedpkg srpm** - Create a “*.src.rpm” file

-   **fedpkg scratch-build -\\\-srpm=389-ds-base-1.4.0.12-1.xxxxx.src.rpm** - Submits the srpm to the koji build system.  For faster building you can select just a single architecture by using "**-\\\-arches=x86_64**", but beware you won't catch any build issues on other platforms so use this with caution.

-   **fedpkg clog**

-   **git commit -a -F clog**

-   **git push origin BRANCH**

-   Do the official Koji build, and update bodhi

-   **fedpkg build -\\\-nowait**

-   An email will be sent from Koji telling you if the build was successful

-   Once builds are done, and you received an email, run **fedpkg update** and edit as follows:

        type=bugfix
        request=testing
        bugs= <leave blank if there are no “Fedora OS” specific bugs included in the release>
        autokarma=True
        stable_karma=1
        unstable_karma=-1

-   Do **fedpkg update** for each branch you did a build for.  This will submit this build to "bohdi" for the final Fedora release


DS - push the updates and the tag
---------------------------------

NOTE: Do not push the tags until you are sure the builds were successful! Once you push a tag, you cannot change it - if you need to make a change to fix a build problem, you will essentially have to repeat all of the steps again, since this will involve a new source version.

NOTE: Do not git push -\\\-tags - you may inadvertently push tags you did not intend - push tags specifically by name

-   **cd /home/source/ds389/ds**

-   **git push origin 389-ds-base-1.4.4**

-   **git push origin refs/tags/389-ds-base-1.4.4.12**


Update The Wiki (internal use only)
------------------------------------

-   Upload the source tarball to GitHub <https://github.com/389ds/389-ds-base/releases/new>

-   Create a release note under the following directory (follow the previous release note as a template)

        /SOURCE/docs/389ds/releases/

-   Update the main page under the **News** Section.  Keep the number of releases under 10 - we do not want to crowd the homepage.

        /SOURCE/index.md

-   Update the "release notes" page with the new release note

        /SOURCE/docs/389ds/releases/release-notes.md

-   Update the sources page

        /SOURCE/docs/389ds/development/source.md

-   Push your updates

-   Send email notifications about the new build to these lists, using this Subject:  **Announcing 389 Directory Server #.#.#**

    - <389-announce@lists.fedoraproject.org>
    - <389-users@lists.fedoraproject.org>

-   Done!
