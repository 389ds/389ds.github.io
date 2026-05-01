---
title: "Fedora Release Process"
---

# Fedora Release Process
------------------------
{% include toc.md %}

> **Note on examples:** the commands below use `2.4.4` as the example version and `<active-fedora>` as a placeholder for the Fedora branch (e.g. `f42`, `f43`, `rawhide`). Substitute the version you are releasing and the branch you are targeting.

> **Release order — read first.** The canonical sequence is:
> 1. Tag and generate the source tarball locally (DS section below).
> 2. Push the tag upstream (see *DS - Push the updates and the tag*).
> 3. **Create the GitHub release** and attach the tarball as a release asset (see *DS - GitHub release*).
> 4. **Build Fedora Rawhide using the tarball downloaded from the GitHub release** — do not regenerate a fresh tarball at this point. The GH release artifact is the canonical source for everything downstream (Fedora and lib389), so all consumers install the same bytes.
> 5. Repeat the Fedora build on each stable branch (`f43`, `f42`, ...) using the same GH release tarball, then submit Bodhi updates.
> 6. Publish lib389 to PyPI ([howto](howto-lib389-pypi-release.html)) once the GH release exists and Fedora Rawhide is in.

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
- Update **VERSION.sh** and set the new version string. Then run `python3 src/lib389/validate_version.py --update` to sync `src/lib389/pyproject.toml` before you tag or run **`make -f rpm.mk dist-bz2`**: the tarball you upload to Fedora (Rawhide first) includes `src/lib389/`, and a mismatch here only surfaces at the eventual PyPI release.

      git commit -a -m "Bump version to 2.4.4"


- Apply tag / Generate the source tarball / Generate changelog file (`SKIP_AUDIT_CI=1` skips the npm audit step during the dist build)

        rm -rf src/cockpit/389-console/dist src/cockpit/389-console/cockpit_dist

        TAG=389-ds-base-2.4.4    ; git tag $TAG ; export TAG ; SKIP_AUDIT_CI=1 make -f rpm.mk dist-bz2 ; git log --oneline 389-ds-base-2.4.3.. > /tmp/cl-info

- Notes:
	- Changelog file (**/tmp/cl-info**) is used for updating the specfile changelog section and release notes. Remove the hash prefix value for all bugzilla and github issues. Leave the hash for coverity/misc updates.
	- All commits must be done before **git tag**, otherwise you might need to use **git tag -f \$TAG**
	- Do not forget the revision range notation


### **DS** - GitHub release

Once the tag has been pushed upstream, publish the GitHub release **before** uploading anything to Fedora dist-git. The tarball attached here is the canonical source artifact: Fedora Rawhide, the stable Fedora branches, and lib389 on PyPI all consume **the same bytes** from this GH release.

- Draft a new release at <https://github.com/389ds/389-ds-base/releases/new> against the pushed tag (e.g. `389-ds-base-2.4.4`).
- Attach the source tarball generated above (`389-ds-base-2.4.4.tar.bz2`) and, when applicable, `jemalloc-5.3.0.tar.bz2` as release assets.
- Publish the release.

Then download the published tarball locally — the rest of this document assumes the Fedora `fedpkg new-sources` / `fedpkg upload` step uses **this file**, not a freshly regenerated one. Re-download `jemalloc-*.tar.bz2` the same way only if it was refreshed for this release; otherwise the existing copy in the lookaside cache is reused.

        GH_TAG=389-ds-base-2.4.4
        cd /home/$USER/source/ds389/389-ds-base
        curl -L -O https://github.com/389ds/389-ds-base/releases/download/$GH_TAG/$GH_TAG.tar.bz2


### **Fedora** - Dist-Git - New release
In general, when we do a new build, we push changes to rawhide first, so that the development branch has the newest bits, then to currently supported Fedora releases. The fedpkg commands below use `<active-fedora>` as a placeholder for the target branch (`rawhide`, `f42`, `f43`, ...); start with `rawhide`, then repeat the same steps on each stable branch you need to update.

> **Use the GH release tarball.** Both `fedpkg new-sources` and `fedpkg upload` below must point at the tarball downloaded from the GitHub release in the previous section, not a locally regenerated one. This is what guarantees Fedora and PyPI ship matching artifacts.

- Checkout the source

        cd /home/$USER/source/fedora/389-ds-base
        git checkout <active-fedora>

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

	- Update new changelog entry header (Paste the line generated). `$VERSION` should be set to the release version, e.g. `VERSION=2.4.4`.

                cd /home/$USER/source/ds389/389-ds-base
                git log -n 1 --pretty=format:"* %ad %an <%ae> - $VERSION" --date=format:"%a %b %d %Y"
                cd /home/$USER/source/fedora/389-ds-base


	- Update new changelog entry commits from the changelog (/tmp/cl-info), paste from clipboard into spec file

			sed 's/^[^ ]*/-/' /tmp/cl-info | xclip

- Config kerb / Confirm version / Upload tar file. The `389-ds-base-*.tar.bz2` referenced below is the **tarball downloaded from the GitHub release**, not a freshly regenerated one (see *DS - GitHub release*).

        kinit <FAS_USERNAME>@FEDORAPROJECT.ORG
        fedpkg verrel
        fedpkg new-sources /home/$USER/source/ds389/389-ds-base/389-ds-base-2.4.4.tar.bz2  /home/$USER/source/ds389/389-ds-base/jemalloc-5.3.0.tar.bz2

- Re-upload **jemalloc** only if it changed since the previous release; otherwise the source tarball alone is enough. If the sources entry already exists in lookaside, use `fedpkg upload` instead:

        fedpkg upload /home/$USER/source/ds389/389-ds-base/389-ds-base-2.4.4.tar.bz2

- **git status** - Should show the "sources" and ".gitignore" are staged

- Remove any useless tarballs from the  **sources** file

- Create a "*.src.rpm" file

        fedpkg --release <active-fedora> srpm

- Do a scratch build to make sure everything is working. Use the exact `.src.rpm` filename produced by the previous step — fedpkg names it with the actual Fedora version (`fc42`, `fc43`, ...), which for `rawhide` is whatever Rawhide currently maps to:

        fedpkg --release <active-fedora> scratch-build --srpm=389-ds-base-2.4.4-1.fcNN.src.rpm --arches=x86_64

- If the build is successful generate a clog (change log file)

        fedpkg clog

- Commit the changes

        git commit -a -F clog

- Push the changes

        git push origin <active-fedora>

- Do the official Koji build, save the resulting URL for later

        fedpkg --release <active-fedora> build --nowait

- An email will be sent from Koji telling you if the build was successful, or can just monitor the build link

- Do **fedpkg update** for each stable branch you did a build for. This will submit the build to Bodhi for the final Fedora release. Save the resulting URL for later. Skip this step for **rawhide** — Rawhide builds do not go through Bodhi.

        fedpkg update

- And edit as follows:

        type=bugfix
        request=testing
        bugs= <leave blank if there are no "Fedora OS" specific bugs included in the release>
        autokarma=True
        stable_karma=1
        unstable_karma=-1


### lib389 PyPI (after the GH release and Fedora Rawhide)

Publish **lib389** to PyPI **after** the GitHub release exists and the Fedora **Rawhide** build has gone in. The order matters: the GH release defines the canonical tarball, Fedora Rawhide is the first downstream consumer of those bytes, and lib389 is the third — releasing PyPI first or skipping ahead of Rawhide breaks the "everyone installs the same artifact" guarantee.

You do **not** need to wait for Bodhi to reach stable, or for the rebuilds on stable Fedora branches — the trigger is "GH release published + Rawhide built". See [How to lib389 PyPI release](howto-lib389-pypi-release.html) for the full procedure.


### **Fedora** - Dist-Git Option 2 - Test build with patches

Assume the rawhide branch contains some fixes that are partial (or broken) and you want to do a rawhide build with a crafted list of patches

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

        fedpkg scratch-build --srpm=389-ds-base-2.0.4-3.xxxxx.src.rpm --arches=x86_64
        fedpkg clog
        git commit -a -F clog
        git push origin rawhide

- Do the official Koji build, and update bodhi

        fedpkg build --nowait

- You are **done** (no fedpkg update, no release note, no mail)


### **DS** - Push the updates and the tag

NOTE: Do not push the tag until the local `make -f rpm.mk dist-bz2` build has completed successfully (per the release-order overview, the tag push happens before the GitHub release and the Koji builds). Once you push a tag, you cannot change it - if you need to make a change to fix a build problem, you will essentially have to repeat all of the steps again, since this will involve a new source version.

NOTE: Do not git push -\\\-tags - you may inadvertently push tags you did not intend - push tags specifically by name

        cd /home/$USER/source/ds389/389-ds-base
        git push origin 389-ds-base-2.2
        git push origin refs/tags/389-ds-base-2.2.2


### Update The Wiki (internal use only)

Ghostwriter is useful for previewing markdown file changes.

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

        sha512sum 389-ds-base-2.4.4.tar.bz2
        /home/$USER/source/dswiki/389ds.github.io/docs/389ds/development/source.md

-   Push your updates

-   Send email notifications about the new build to these lists, using this Subject:  **Announcing 389 Directory Server #.#.#**

    - <389-announce@lists.fedoraproject.org>
    - <389-users@lists.fedoraproject.org>

-   Done!

