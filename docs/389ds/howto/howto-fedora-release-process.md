---
title: "Fedora Release Process"
---

# Fedora Release Process
------------------------

{% include toc.md %}


### Prerequisites

You will need a FAS account at <https://admin.fedoraproject.org/accounts/user/new>

- You will need to create an ssh key pair and upload your public key
- You will need your ssh key in order to push updates to the 389 git repo
- You will need a Fedora cert (\~/.fedora.cert) - when you get your FAS account, it should prompt you to get a cert

git push access - you will need to be a member of the git389 group in FAS

- Requires a FAS account
- <https://admin.fedoraproject.org/accounts/group/view/git389>
- Request access, then bug a 389 developer to add you

#### **DS** = the 389 source code SCM

    git clone git@github.com:389ds/389-ds-base.git

#### **Fedora** = the 389-ds-base dist-git repo which contains the specfile

    fedpkg clone 389-ds-base


### **DS** - checkout the source, add the fixes, set the version, tag it, and archive it

    mkdir /home/source/ds389; cd /home/source/ds389
    git clone git@github.com:389ds/389-ds-base.git
    cd 389-ds-base
    git checkout 389-ds-base-x.x

- Commit any fixes that have not yet been applied

- Do a **git log** to make sure all the commits are done!

- Update **VERSION.sh** and set the new version string

        git commit -a -m “Bump version to <new version>"

- All commits must be done before **git tag**! Otherwise you might need to use **git tag -f \$TAG**

- Generate the source tarball, and changelog file (used for updating the specfile's changelog and the wiki release notes)

        rm -rf src/cockpit/389-console/dist src/cockpit/389-console/cockpit_dist

        TAG=389-ds-base-1.3.9.1  ; git tag $TAG ; git archive --prefix=$TAG $TAG | bzip2 > $TAG.tar.bz2 ; git log --oneline 389-ds-base-1.3.9.0.. > /tmp/cl-info
        TAG=389-ds-base-1.4.3.39 ; git tag $TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log --oneline 389-ds-base-1.4.3.38.. > /tmp/cl-info
        TAG=389-ds-base-2.2.10   ; git tag $TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log --oneline 389-ds-base-2.2.9.. > /tmp/cl-info
        TAG=389-ds-base-2.3.8    ; git tag $TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log --oneline 389-ds-base-2.3.7.. > /tmp/cl-info
        TAG=389-ds-base-2.4.7    ; git tag $TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log --oneline 389-ds-base-2.4.6.. > /tmp/cl-info

- Edit the **/tmp/cl-info** file. Remove the hash prefix value for all bugzilla and github issues. Leave the hash for coverity/misc updates.

### **Fedora** - Dist-Git - New release

    git checkout rawhide  (or f39, f38, ...)

- Go back to the source directory, which should be uncleaned after the tarball creation 

        cd /home/source/ds389/389-ds-base

- Update Fedora spec file with Rust packages data 

        DS_SPECFILE=/home/mareynol/source/FEDORA/389-ds-base/389-ds-base.spec make -f rpm.mk bundle-rust
        
    - On 1.4.3:

            FEDORA_SPECFILE=/home/mareynol/source/FEDORA/389-ds-base/389-ds-base.spec make -f rpm.mk bundle-rust-on-fedora

- Go back to Fedora repo directory 

        cd /fedora/389-ds-base

- Run **git diff** and check that spec file has only "License:" field changes and 'Provides:  bundled(crate(*' replacements and the rest was not touched by the script

- Edit the spec file **/fedora/389-ds-base/389-ds-base.spec**

- Read the instructions around 'License:' field and remove the comments accordingly

- Edit **389-ds-base.spec** with version/changelog (see paragraph below)

        kinit your_id@FEDORAPROJECT.ORG
        fedpkg verrel
        fedpkg new-sources /home/source/ds389/389-ds-base-1.4.1.6.tar.bz2 /home/source/ds389/jemalloc-5.1.0.tar.bz2
    
- Add tar ball created by git archive cmd from above, and always include **jemalloc**. Another option is just **uploading** the recent tarball 

        fedpkg upload /home/source/ds389/389-ds-base-1.4.1.6.tar.bz2**

- **git status** - Should show the "sources" and ".gitignore" are staged

- Remove any useless tarballs from the  **sources** file

- Create a “*.src.rpm” file
     
        fedpkg --release fxx srpm

- Do a scratch build to m ake sure ewfverything is working

        fedpkg --release fxx scratch-build --srpm=389-ds-base-1.4.0.12-1.xxxxx.src.rpm --arches=x86_64

- If the build is successful generatea clog (change log file)

        fedpkg clog

- Commit the changes

        git commit -a -F clog

- Push the changes

        git push origin rawhide

- Do the official Koji build, and update bodhi

        fedpkg --release fxx build --nowait

- An email will be sent from Koji telling you if the build was successful, or can just monitor the build link

- Do **fedpkg update** for each branch you did a build for.  This will submit this build to "bohdi" for the final Fedora release

        fedpkg update
        
- And edit as follows:

        type=bugfix
        request=testing
        bugs= <leave blank if there are no “Fedora OS” specific bugs included in the release>
        autokarma=True
        stable_karma=1
        unstable_karma=-1


### **Fedora** - Dist-Git Option 2 - Test build with patches

Let assume rawhide branch contains some fixes that are partial (or broken) and you want to do a rawhide build with a crafted list of patches

- Prepare the source with selected list of patches on top of **2.0.4** for example

        git clone git@github.com:389ds/389-ds-base.git
        cd 389-ds-base
        git checkout -b upstream_2.0.4_plus_db_suffix

- Rebase on **Bump version to 2.0.4.3** and apply the patches

- Then for each patch do git format-patch -\<number of patches\>

- On fedpkg

        fedpkg clone 389-ds-base
        cd 389-ds-base
    
- Upload the source tarball (should not be necessary as it was already done): 

        fedpkg upload <source>/389-ds-base-2.0.4.tar.bz2
    
- Go back to the source directory (see above), which should be uncleaned after the tarball creation
- Copy the patches from the source tree (taking care of the numbering)
- Update Fedora spec file with Rust packages data 

        DS_SPECFILE=\<fedpkg\>/389-ds-base/389-ds-base.spec make -f rpm.mk bundle-rust

- Edit spec file to add the patches

        ...
        ...
        Source0:          https://releases.pagure.org/389-ds-base/%{name}-%{version}%{?prerel}.tar.bz2
        # 389-ds-git.sh should be used to generate the source tarball from git
        Source1:          %{name}-git.sh
        Source2:          %{name}-devel.README
        %if %{bundle_jemalloc}
        Source3:          https://github.com/jemalloc/%{jemalloc_name}/releases/download/%{jemalloc_ver}/%{jemalloc_name}-%{jemalloc_ver}.tar.bz2
        %endif
        
        +Patch0:           0000-Issue-db_suffix.patch
        +Patch1:           0001-Issue-foo.patch
        ...
        ...

        $ git add <all patch files>
    
- edit the *source* file to keep only the right one

- Verify changes to spec file is producing the correct version

        fedpkg verrel

- Check the patches applied correctly

        fedpkg prep

- Remove useless tarballs from **sources** file
- Create srpm file

        fedpkg srpm

- Do scratch build. commit and push changes

        fedpkg scratch-build --srpm=389-ds-base-2.0.4-3.xxxxx.src.rpm** **--arches=x86_64
        fedpkg clog
        git commit -a -F clog
        git push origin rawhide

- Do the official Koji build, and update bodhi

        fedpkg build --nowait

- You are **done** (no fedpkg update, no release note, no mail)


### **DS** - Push the updates and the tag

NOTE: Do not push the tags until you are sure the builds were successful! Once you push a tag, you cannot change it - if you need to make a change to fix a build problem, you will essentially have to repeat all of the steps again, since this will involve a new source version.

NOTE: Do not git push -\\\-tags - you may inadvertently push tags you did not intend - push tags specifically by name

    cd /home/source/ds389/ds
    git push origin 389-ds-base-2.2
    git push origin refs/tags/389-ds-base-2.2.2


### Update The Wiki (internal use only)

-   Checkout the wiki source code

        git clone git@github.com:389ds/389ds.github.io.git

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

