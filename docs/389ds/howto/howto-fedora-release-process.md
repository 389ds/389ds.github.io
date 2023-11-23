---
title: "Fedora Release Process"
---

# Fedora Release Process
------------------------
{% include toc.md %}

### Prerequisites

- A FAS account at https://accounts.fedoraproject.org/
	- You will need to create an ssh key pair and upload your public key in order to push updates

- You will need to be a member of the following groups
	- https://accounts.fedoraproject.org/group/git389/
		+ Contact a sponsor for access
	- https://accounts.fedoraproject.org/group/packager/
		* See https://docs.fedoraproject.org/en-US/package-maintainers/Joining_the_Package_Maintainers/ for access
    - https://src.fedoraproject.org/rpms/389-ds-base
        * Contact a member for access


#### **DS** = 389-ds-base source code repo

    mkdir -p /home/$USER/source/ds389; cd /home/$USER/source/ds389
    git clone git@github.com:389ds/389-ds-base.git

#### **Fedora** = 389-ds-base dist-git repo which contains the specfile

    mkdir -p /home/$USER/source/fedora; cd /home/$USER/source/fedora
    fedpkg clone 389-ds-base

### **DS - Using an existing branch**

- Checkout the source

      cd /home/$USER/source/ds389/389-ds-base
      git checkout 389-ds-base-2.4

- Commit any fixes that have not yet been applied
- Update **VERSION.sh** and set the new version string

      git commit -a -m “Bump version to 2.4.4"


- Apply tag / Generate the source tarball / Generate changelog file

        rm -rf src/cockpit/389-console/dist src/cockpit/389-console/cockpit_dist

        TAG=389-ds-base-1.3.9.1  ; git tag $TAG ; git archive --prefix=$TAG $TAG | bzip2 > $TAG.tar.bz2 ; git log --oneline 389-ds-base-1.3.9.0.. > /tmp/cl-info
        TAG=389-ds-base-2.4.4    ; git tag $TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log --oneline 389-ds-base-2.4.3.. > /tmp/cl-info

- Notes:
	- Changelog file (**/tmp/cl-info**) is used for updating the specfile changelog section and release notes. Remove the hash prefix value for all bugzilla and github issues. Leave the hash for coverity/misc updates.
	- All commits must be done before **git tag**, otherwise you might need to use **git tag -f \$TAG**
	- Dont forget the revision range notation


### **Fedora** - Dist-Git - New release
In general, when we do a new build, we push changes to rawhide first, so that the development branch has the newest bits, then to active Fedora releases ( f39, f40)

- Checkout the source

        cd /home/$USER/source/fedora/389-ds-base
        git checkout f39

- Go back to the DS source directory, which should be uncleaned after the tarball creation

        cd /home/$USER/source/ds389/389-ds-base

- Update Fedora spec file with Rust packages data 

        DS_SPECFILE=/home/$USER/source/fedora/389-ds-base/389-ds-base.spec make -f rpm.mk bundle-rust
        
    - On 1.4.3:

                FEDORA_SPECFILE=/home/$USER/source/fedora/389-ds-base/389-ds-base.spec make -f rpm.mk bundle-rust-on-fedora

- Go back to Fedora repo directory 

        cd /home/$USER/source/fedora/389-ds-base

- Run **git diff** and check that spec file has only "License:" field changes and 'Provides:  bundled(crate(*' replacements and the rest was not touched by the script

- Update spec file

	- Read the instructions around 'License:' field and remove the comments accordingly

	- Update version

	- Update new changelog entry header (Paste the line generated)
                
                cd /home/$USER/source/ds389/389-ds-base
                git log -n 1 --pretty=format:'* %ad %an <%ae> - 2.4.4' --date=format:"%a %b %d %Y"
                cd /home/$USER/source/fedora/389-ds-base


	- Update new changelog entry commits from the changelog (/tmp/cl-info), paste from clipboard into spec file

			sed 's/^[^ ]*/-/' /tmp/cl-info | xclip

- Config kerb / Confirm version / Upload tar file

        kinit <FAS_USERNAME>@FEDORAPROJECT.ORG
        fedpkg verrel
        fedpkg new-sources /home/$USER/source/ds389/389-ds-base/389-ds-base-2.4.4.tar.bz2  /home/$USER/source/ds389/389-ds-base/jemalloc-5.3.0.tar.bz2

- Add tar ball created by git archive cmd from above, and always include **jemalloc**. Another option is just **uploading** the recent tarball (lookaside cache)

        fedpkg upload /home/$USER/source/ds389/389-ds-base/389-ds-base-2.4.4.tar.bz2**

- **git status** - Should show the "sources" and ".gitignore" are staged

- Remove any useless tarballs from the  **sources** file

- Create a “*.src.rpm” file
     
        fedpkg --release f39 srpm

- Do a scratch build to make sure everything is working

        fedpkg --release f39 scratch-build --srpm=389-ds-base-2.4.4-1.fc39.src.rpm --arches=x86_64

- If the build is successful generate a clog (change log file)

        fedpkg clog

- Commit the changes

        git commit -a -F clog

- Push the changes

        git push origin f39

- Do the official Koji build, save the resulting URL for later

        fedpkg --release f39 build --nowait

- An email will be sent from Koji telling you if the build was successful, or can just monitor the build link

- Do **fedpkg update** for each branch you did a build for.  This will submit this build to "bohdi" for the final Fedora release. Save the resulting URL for later

        fedpkg update
        
- And edit as follows:

        type=bugfix
        request=testing
        bugs= <leave blank if there are no “Fedora OS” specific bugs included in the release>
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

I found ghostwriter useful for displayig the markdown file changes.

-   Checkout the wiki source code

        mkdir -p /home/$USER/source/dswiki; cd /home/$USER/source/dswiki
        git clone git@github.com:389ds/389ds.github.io.git

-   Create a release note under the following directory (follow the previous release note as a template)

        /home/$USER/source/dswiki/389ds.github.io/docs/389ds/releases/release-2-4-4.md

-   Update the main page under the **News** Section.  Keep the number of releases under 10 - we do not want to crowd the homepage.

        /home/$USER/source/dswiki/389ds.github.io/index.md

-   Update the "release notes" page with the new release note

        /home/$USER/source/dswiki/389ds.github.io/docs/389ds/releases/release-notes.md

-   Update the sources page

        sha512sum 389-ds-base-2.4.4.tar.gz
        /home/$USER/source/dswiki/389ds.github.io/docs/389ds/development/source.md

-   Push your updates

-   Send email notifications about the new build to these lists, using this Subject:  **Announcing 389 Directory Server #.#.#**

    - <389-announce@lists.fedoraproject.org>
    - <389-users@lists.fedoraproject.org>

-   Done!

