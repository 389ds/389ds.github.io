---
title: "Howto: Do Pull Requests in Pagure"
---

How to do Pull Requests in Pagure
-----------------------------

## Description

This is a brief discussion on one way you can setup your workspace to use *Pull Requests* in Pagure.  This is the current method the Directory Server development uses, and to make it easier to contribute it would be best to use this same approach.

## Setup Your Workspace

You must first create a fork of the project, then you will clone the main repo, and add your fork to it.  Then initialize your new fork with master branch (this is a one time task for setting up the fork for the first time).

    $ git clone ssh://git@pagure.io/389-ds-base.git
    $ cd 389-ds-base
    $ git checkout master
    $ git pull
    $ git remote add myfork ssh://git@pagure.io/forks/your_username/389-ds-base.git
    $ git push myfork --force


## Work On A New Fix

You will create a new branch under the *master* branch.  Make changes and commit them as usual.  When you are done you will need to push your new branch to your fork.

    $ git checkout master
    $ git pull
    $ git checkout -b ticket49999
    $ git commit -a -m "My Fix!"
    $ git push myfork


Then file a pull-request in Pagure,  You will see this branch (ticket49999) in the Pagure UI.  Then send out a "please review" email to 389-devel mailing list <389-devel@lists.fedoraproject.org>.


## Amending A Fix

So to make changes to a PR go to your branch, make changes, and commit them.  Then you MUST do *forced* push to your fork which will automatically update the PR.

    $ git checkout ticket49999
    $ <make source changes>
    $ git commit -a --amend
    $ git push myfork --force 


## Merging Your PR

Once you gets your acks or *LGTM (Looks Good To Me)*, then rebase your branch with master again, in case someone else pushed a patch, and then push the branch to your fork again.

    $ git checkout master
    $ git pull
    $ git checkout ticket49999
    $ git rebase master
    $ git push myfork --force


Now the PR can be merged using the Pagure UI.

That's it!


