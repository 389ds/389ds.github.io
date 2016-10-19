---
title: "Fedora Release Process"
---

# Fedora Release Process
------------------------

{% include toc.md %}

### Pre-Requisites

Fedora already has all of the packaging packages in the default repos - no additional configuration is required.

If you are using RHEL/CentOS/similar derivative to do Fedora packaging, you will need to configure the EPEL repos. For example, for EL6:

    yum install http://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm

Then, install the packager packages:

    yum install fedpkg fedora-packager

You will need a FAS account at <https://admin.fedoraproject.org/accounts/user/new>

-   you will need to create an ssh key pair and upload your public key
-   you will need your ssh key in order to push updates to the 389 git repo
-   you will need a Fedora cert (\~/.fedora.cert) - when you get your FAS account, it should prompt you to get a cert

git push access - you will need to be a member of the git389 group in FAS

-   Requires a FAS account
-   <https://admin.fedoraproject.org/accounts/group/view/git389>
-   Request access, then bug a 389 developer to add you

DS = the 389 source code SCM - <ssh://git.fedorahosted.org/git/389/ds.git>

Fedora = the DS clone location which contains the spec files - <git://pkgs.fedoraproject.org/389-ds-base.git> (use **fedpkg clone 389-ds-base**)

DS - checkout the source, add the fixes, set the version, tag it, and archive it
--------------------------------------------------------------------------------

-   **mkdir /home/source/ds389; cd /home/source/ds389**

-   **git clone <ssh://git.fedorahosted.org/git/389/ds.git>**

-   **cd ds**

-   **git checkout 389-ds-base-1.x.x**

-   Commit any fixes that have not yet been applied

-   Do a **git log** to make sure all the commits are done

-   Open/edit **VERSION.sh**

-   Make sure **VERSION\_PREREL** is commented out

-   Set the new version

-   **git add VERSION.sh**

-   **git commit -m “**bump version to \<new version\>**"**

-   All commits must be done before **git tag**! Otherwise you might need to use **git tag -f \$TAG**

-   **NAME=389-ds-base ; VERSION=1.2.11.30 ; TAG=\$NAME-\$VERSION**

-   **git tag \$TAG**

-   **git archive -\\\-prefix=\$TAG/ \$TAG \| bzip2 \> \$TAG.tar.bz2**

Fedora - Clone it, and update the spec files
--------------------------------------------

-   **mkdir /fedora; cd /fedora**

-   **fedpkg clone 389-ds-base**

-   **cd /fedora/389-ds-base/**

-   **fedpkg switch-branch master** - Make sure you’re on master

-   Edit the **389-ds-base*.sh** & **389-ds-base.spec** files, and change the version. In the spec file make sure the **release** field is set back to **1: %{?relprefix}1%{?prerel}%{?dist}**

DS - Create version specific archive and gather the changes
-----------------------------------------------------------

-   **cd /home/source/ds389/ds**

-   **sh -x /home/source/fedora/389-ds-base/389-ds-base-git-local.sh /home/source/ds389/ds** --> this does the same thing as the git archive command above

-   **git log -\\\-oneline 389-ds-base-1.2.11.29.. \> /tmp/cl-info** - The version should be the current version. This gathers all the changes since the last release.

-   Edit the **/tmp/cl-info** file. Remove the hash prefix value for all bugzilla and trac bugs. Leave the hash for coverity/misc updates.

Fedora - Finish editing the spec file, verify the version, and do the scratch-build
-----------------------------------------------------------------------------------

-   **cd /fedora/389-ds-base/**

-   First copy the contents of the edited **cl-info** file

-   Edit the spec file **/fedora/389-ds-base/389-ds-base.spec**

-   Goto the **changelog** section

-   Add the header line:

       * Fri Feb 3 2013 Mark Reynolds     <mreynolds@redhat.com>     - 1.2.11.30-1

-   Then copy in the contents of **cl-info** underneath the header

-   **fedpkg verrel** - Verify changes to spec file are producing the correct version.

-   **fedpkg new-sources /home/source/ds389/389-ds-base-1.2.11.30.tar.bz2**

-   **git status** - Should show the "sources" and ".gitignore" are staged

-   **fedpkg srpm** - Create a “*.src.rpm” file

-   **fedpkg scratch-build -\\\-srpm=389-ds-base-1.2.11.30-1.xxxxx.src.rpm** - Submits the srpm to the koji build system. Takes a few minutes to run.

-   **fedpkg clog**

-   **git commit -a -F clog**

-   **git push**

-   If you need to update sub branches of master
    -    **fedpkg switch-branch \<branch\>**
    -    **git merge master**
    -    NOTE: if git merge fails, do a *git cherry-pick* instead - **git cherry-pick -x master**
    -    You may to run this if the sources file was not updated:  **fedpkg new-sources /home/source/ds389/389-ds-base-1.2.11.30.tar.bz2**  Followed by a "git commit -a" after the scratach build completes.
    -    **fedpkg verrel**
    -    **fedpkg srpm**
    -    **fedpkg scratch-build -\\\-srpm=389-ds-base-1.2.11.30-1.xxxxx.src.rpm**
    -    **git push**


Fedora - Do the official Koji build, and do the release "update"
----------------------------------------------------------------

-   **fedpkg switch-branch master**

-   **fedpkg build -\\\-nowait**

-   Do this for each branch that you are building.

    **for br in f25 f24 ; do fedpkg switch-branch $br ; fedpkg build -\\\-nowait ; done**

-   An email will be sent from Koji telling you if the build was successful

-   Once builds are done, and you received an email, run **fedpkg update** and edit as follows:

        type=bugfix
        request=testing
        bugs= <leave blank if there are no “Fedora OS” specific bugs included in the release>
        autokarma=True
        stable_karma=1
        unstable_karma=-1

-   Do **fedpkg update** for each branch you did a build for.

DS - push the updates and the tag
---------------------------------

NOTE: Do not push the tags until you are sure the builds were successful! Once you push a tag, you cannot change it - if you need to make a change to fix a build problem, you will essentially have to repeat all of the steps again, since this will involve a new source version.

NOTE: Do not git push -\\\-tags - you may inadvertently push tags you did not intend - push tags specifically by name

-   **cd /home/source/ds389/ds**

-   **git push origin 389-ds-base-1.2.11**

-   **git push origin refs/tags/389-ds-base-1.2.11.30**

Update The Wiki (internal use only)
------------------------------------

-   Upload the source tarball

        rhc scp website upload 389-ds-base-1.3.3.tar.bz2 app-root/data/

-   Create a release note under the following directory (follow the previous release note as a template) 

        /SOURCE/website/releases/

-   Update the main page under the **News** Section.  Keep the number of releases under 10 - we do not want to crowd the homepage.

        /SOURCE/website/index.md

   -   If the release list now exceeds 10 releases, then move older releases from the home page to the archive page

            /SOURCE/website/docs/389ds/releases/news-archive.md
 
-   Update the "release notes" page with the new release note

        /SOURCE/website/docs/389ds/releases/release-notes.md

-   Update the sources page

        /SOURCE/website/docs/389ds/development/source.md

-   Push your updates

-   Done!


