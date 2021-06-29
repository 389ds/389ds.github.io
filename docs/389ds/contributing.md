---
title: Contributing to 389 Directory Server
---

# Contributing to 389 Directory Server
----------------------------------

{% include toc.md %}

Why should I contribute to 389 Directory Server?
------------------------------------------------

389 Directory Server is a high performance LDAP server, trusted and used around the world for identity management and authentication systems. It is the foundation of other open source projects, and businesses everywhere - from universities to cloud providers. The project is well known for its engineering excellence, stability and performance.

Contributing to 389 Directory Server is an opportunity to connect with a global team of engineers working on a high profile open source project. Not only will you be able to learn valuable engineering skills, your contribution will help to improve a project that impacts the security of individuals and businesses around the world.

We welcome individuals of all skill levels and backgrounds.

Directory Server is huge! Where do I even start?
------------------------------------------------

Before you jump into the code, here are some things you can do to familarise yourself with the 389 Directory Server project:

-   Read our [code of conduct](https://getfedora.org/code-of-conduct).
-   Install a 389 Directory Server instance
    -   Add [users and groups](howto/howto-users-and-groups.html)
    -   Connect SSSD for [system authentication](howto/howto-sssd.html)
    -   Explore and enable Directory Server plugins
-   Join our [users mailing list](https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org/)
    -   Once you join, introduce yourself
    -   Ask questions, we are always happy to help
-   Do you have ideas of what could be better? Found something which might be an issue? Raise an issue on [github](https://github.com/389ds/389-ds-base)
    -   Raising a bug is just as important as the fix itself
    -   To use [github](https://github.com/389ds/389-ds-base) you need to have a GitHub account
-   Take a look at the list of [easy fix](https://github.com/389ds/389-ds-base/labels/easy%20fix) issues
    -   Join our [developers mailing list](https://lists.fedoraproject.org/admin/lists/389-devel.lists.fedoraproject.org/), and let us know you want to contribute code. We'll help you through the process.
    -   Create a [third party plugin](third-party.html) to add or extend features

Many of us in the team started by asking questions and raising bugs.

Communicating with the team
---------------------------

We can be contacted via our mailing lists for [users](https://lists.fedoraproject.org/admin/lists/389-users.lists.fedoraproject.org/) or [developers](https://lists.fedoraproject.org/admin/lists/389-devel.lists.fedoraproject.org/).

We are often in irc on irc.libera.chat - we use the #389 channel. We are distributed all around the world, so we may not answer. Email is your best communication option.

Issues and requests for enhancement can be raised on our [github instance](https://github.com/389ds/389-ds-base/)


Building the project
--------------------

### What you will need

We recommend Fedora or CentOS as build platforms: this is what our team uses, so it works very well.

### Get the code:

|Component|GIT Repository|Clone the Repository|
|---------|------|
|**Directory Server** | <https://github.com/389ds/389-ds-base.git>| git clone https://github.com/389ds/389-ds-base.git<br>git clone git@github.com:389ds/389-ds-base.git|

#### Source tarballs

Also see our source code & tarball page [here](development/source.html)

### Get the dependencies

On Fedora:

    sudo dnf install @buildsys-build make
    # This grabs the *runtime* requirements rather than rpm build requirements
    sudo dnf install --setopt=strict=False `grep -E "^(Build)?Requires" 389-ds-base/rpm/389-ds-base.spec.in | grep -v -E '(name|MODULE)' | awk '{ print $2 }' | sed 's/%{python3_pkgversion}/3/g' | grep -v "^/" | grep -v pkgversion | sort | uniq | tr '\n' ' '`

On CentOS:

    sudo yum install @buildsys-build make epel-release
    sudo yum install --skip-broken `grep -E "^(Build)?Requires" 389-ds-base/rpm/389-ds-base.spec.in | grep -v -E '(name|MODULE)' | awk '{ print $2 }' | grep -v "^/" | grep -v pkgversion | sort | uniq|  tr '\n' ' '`

### Build and install the server

    cd 389-ds-base/
    autoreconf -fiv
    ./configure --enable-debug --with-openldap --enable-cmocka --enable-asan
    make
    make lib389
    make check
    sudo make install
    sudo make lib389-install

You can build rpms and rpms by using these commands:

    make -f rpm.mk rpms

    make -f rpm.mk srpms

These packages are then located in dist/rpms or dist/srpms

It can happen that the building process will fail on one of the stages with an error about npm vulnerabilities. They can be fixed semi-automaticly by running:

    pushd src/cockpit/389-ds-console
    npm audit fix
    popd

It is advisable to create a separate commit for fixing the audit issues.

Additionally, you may need to skip audit-ci check because you are doing a bisect, checking older commit, or we just want to skip a known issue. For these purposes, we can use an environment variable SKIP_AUDIT_CI as per following:

    SKIP_AUDIT_CI=1 make -f rpm.mk rpms

    SKIP_AUDIT_CI=1 make -f rpm.mk srpms

In 389-ds-base-1.4.0 you can package the source code and latest UI (cockpit plugin/node_modules).  You do have to create a git tag, but you can just delete it after making the tarball

    export TAG=389-ds-base-1.4.0.25 ; git tag $TAG ; make -f rpm.mk dist-bz2

    git tag -d 389-ds-base-1.4.0.25

Set Up a Cockpit UI Development Environment
------------------

If you are working on Cockpit UI patch, it may be handy to have an environment which automatically build when you do a change in the code, so you can see the result in browser right away.

For that, you need to link your local cockpit environment to system-wide cockpit-389-ds directory:

    make 389-console-devel-install

And after that, you can run this command in a separate terminal (so you can monitor for any errors during the development):

    cd ./src/cockpit/389-console
    ./buildAndRun.sh

If you want to have the npm-audit, you need to add '-a' parameter:
        
    ./buildAndRun.sh -a 

So now, every time you make a change in the cockpit-389-ds sourse code and save it, - just refresh the browser to see the change.
    
Testing the server
------------------

Once you have installed the server you can run our tests on them

389-ds-base support cmocka unit tests:

    make check

In addition we ship function tests that deploy and run directory server to test it. You can run these with py.test

    sudo py.test -s 389-ds-base/dirsrvtests/tests/suites/basic/

When you write code, it's a great idea to run our tests as well as providing your own for the feature.

Creating a patch for review
---------------------------

### Fedora Project Contributor Agreement

When you submit code to the 389 Directory Server project, you are required to complete the [Fedora Project Contributor Agreement](https://fedoraproject.org/wiki/Legal:Fedora_Project_Contributor_Agreement). This can be completed on the [Fedora account system](https://admin.fedoraproject.org/accounts/) under the "My Account" tab.

### Fork the repository

Go to <https://github.com/389ds/389-ds-base> and fork the repo. Add the forked repo link as a remote to your local git repo:

    git remote add myfork git@github.com:droideck/389-ds-base.git

Also see the [Pull-Request Cheatsheet](howto/howto-do-pull-requests.html)

### Create your working branch

    git checkout master
    git pull
    git checkout -b my-awesome-feature
    # Your work goes here!

### Ask us for pre-review

When you first start, it's a good idea to ask for advice along the way. We are happy to check your code in a git branch or patch as your progress. We want to help your code improve and be a good submission.

### Getting the patch ready

When you have finished your code, you have had it pre-reviewed, it's time to get the patch ready.

If you are working on existing issue in GitHub, take note of it's issue number and URL.

If you are working on a new feature, make a new RFE issue, and take note of it's issue number and URL.

While you are working on the issue, continue to commit onto HEAD your fixes during the review. Do not force-push.

    git commit
    git push myfork

After the review is done, make sure that your work is a single commit with no extraneous files. You can turn multiple commits into one through a rebase-squash process.

    git log
    # identify the top 3 commits as the work you want to submit
    git rebase -i HEAD~3
    git push myfork --force-with-lease

Now you will see a list of commits like:

    pick 2431753 Issue 48864 - Cleanup memory detection before we add cgroup support
    pick 9b5a69f Issue 49206 - Add missing make dependency
    pick 62e033d Issue 48864 - Add cgroup memory limit detection to 389-ds

These are in order of "oldest to newest".

You want to squash the "newest" commits to your first commit. So you change the lines to the following:

    pick 2431753 Issue 48864 - Cleanup memory detection before we add cgroup support
    squash 9b5a69f Issue 49206 - Add missing make dependency
    squash 62e033d Issue 48864 - Add cgroup memory limit detection to 389-ds

Now save and exit your text editor. You'll be presented with a chance to review the commit message. We like to use the
following format.

    Issue ##### - <SUMMARY>

    Bug Description:

    <DESC>

    Fix Description:

    <DESC>

    relates: <The Issue URL>

    Author: <your name here>

    Reviewed by: ???

Fill in the commit message and save. You now have a single well formed commit to send us.  In GitHub, the "relates" keyword will update that Issue with the commit hash (a very convenient feature).

### Create a pull-request

Push the commit to your remote forked repo

    git push myfork

Go to [389-ds-base Pull Requests](https://github.com/389ds/389-ds-base/pulls),
press *Open PR* button and choose your branch.
Check that all fields have a right information and press *Create Pull Request* button.

Alternatively you can create and upload a patch file (it was an old way before the pull-requests) You can run the next command to generate a patch file from the last commit:

    git format-patch -1

Add the patch file as an attachment to your issue on GitHub.

### Final checks

While we hope you were running tests as you developed your patch, we ask that you run the tests once more here with your single patch to make sure there are no issues here to surprise us!

### Sending a review request

Go to your GitHub issue and set the metadata flag "reviewstatus" to "review".

Finally, send an email to the 389-devel@lists.fedoraproject.org mailing list like the following:

    Subject: Please review: Issue XXXX - fix issue, add feature,...

    https://github.com/389ds/389-ds-base/issues/XXXX

    https://github.com/389ds/389-ds-base/pull/XXXX
    # or a link to the patch

### Collaborate on the review process.

We'll provide comments in the GitHub issue about the code, offering suggestions or asking questions. Finally, once we are happy and have worked with you on the review, we'll set the reviewstatus to "ack", and will merge your code to the master branch.


Creating a new feature
----------------------

Creating a new feature is slightly different to creating a patch to an issue. We ask that you submit a design for review before you start work.

### Talk to us about the idea

Contact us on the 389-devel@lists.fedoraproject.org mailing list about your idea. We'll let you know how best to implement it or approach the problem.

### Write your design document

Follow the [design document template](design/design-template.html), and have a look at other existing designs for inspiration (design/design.html).

### Have the design reviewed

Send the markdown file to 389-devel@lists.fedoraproject.org and we'll discuss it with you. Once you and the team are happy with it, we'll put it on the website.

### Write the feature.

Now, write the code just like you would a patch!

Contribute to the Wiki
----------------------

Simply write up your new page in MarkDown, see [How to write a wiki page](howto/howto-write-wiki-page.html), then file a [issue](https://github.com/389ds/389-ds-base/issues/new), select "**wiki**" as the component, and attach the file.  Then we will post your content asap.

Detailed project processes
--------------------------

-   [Release Procedure](development/release-procedure.html)
-   [Nightly Builds](development/nightly-builds.html)
-   [Plugin Development](design/plugins.html)

Other points of interest
------------------------

-   [Write a Wiki Page](howto/howto-write-wiki-page.html)
-   [History](FAQ/history.html)

Acknowledgements
----------------

Thanks to @charcol for contributing to this page, and advice on its content.
