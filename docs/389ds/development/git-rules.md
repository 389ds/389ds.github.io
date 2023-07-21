---
title: "GIT Rules"
---

# GIT Rules
-----------

It would be nice if, before submitting patches, you could build DS with your change on Fedora or RHEL and at least 1 other platform. This isn't always possible but it helps prevent cross-platform build breakage, and different compilers emit different warnings that can be useful for catching/avoiding bugs.

{% include toc.md %}

Configure git
-------------

At the minimum, you should do this:

    git config --global user.name "Firstname Lastname"    
    git config --global user.email "your_email@youremail.com"    

This will make sure commit messages have your correct contact information.

See **git config --help** for more information.

For example, here is my \~/.gitconfig

    [user]    
        name = Rich Megginson    
        email = rmeggins@redhat.com    
    [commit]    
        template = /home/rich/.gitcommittemplate    

Here is my \~/.gitcommittemplate

    description    
    <ticket url>
    Resolves: Ticket ###    
    Bug Description: description    
    Reviewed by: ???    
    Branch: main    
    Fix Description: description    
    Platforms tested:     <plat>
    Flag Day: no    
    Doc impact: no    

Accept the ticket
-----------------

If there is a trac ticket, e.g. <https://fedorahosted.org/389/ticket/XXX>

In the ticket in the *Modify Ticket* *Action* section, hit the *accept* checkbox.

Create a branch for your work
-----------------------------

Always create a "topic" or "bug" branch for your work.

    git checkout main # or a main release branch    
    git checkout -b ticket123 # short for git branch ticket123 ; git checkout ticket123    
    git checkout -b numericstring # a "feature" branch, not a bug fix branch    

This will create a new branch from the current branch (use *git branch* to show the current branch), and do a checkout to that branch. Then just do the work on this branch.

Rebase changes from other developers
------------------------------------

If you want to get updates from upstream on your working branch, first commit your changes (or use git stash if you have changes you don't yet want to commit), then use git pull or git fetch to get the changes to your local main or main release branch, then use git rebase to rebase your commits on top of the upstream.

-   see what branch you're on

        git branch    
        ...    
        * mytopic    
        ...    

-   save your work in progress - ALWAYS SAVE YOUR WORK

        git add new files added for mytopic work    
        git commit -a -m "saved work in progress on mytopic"    
        OR    
        git stash save "saved work in progress on mytopic"    

-   checkout the main branch or the main release branch you're working off of

        git checkout main # or ReleaseBranch    

-   pull changes from upstream

        git pull upstream main # or ReleaseBranch    
        # If this doesn't pull/merge cleanly, then you have some problems with your    
        # local branch that you must resolve first    

-   go back to your topic branch

        git checkout mytopic    

-   rebase on top of main or ReleaseBranch

        git rebase main # or ReleaseBranch    

-   if you used git stash, apply your stash

        git stash pop # will use stash@{0} by default - be careful if you have more than one stash - git stash list    

-   At this point, you may have conflicts to resolve. The rebase will have placed the conflict markers (\<\<\<\<\<\<) in the file(s) that require manual intervention. You can use a tool like meld to manually resolve conflicts.

        # git stash pop example    
        CONFLICT (content): Merge conflict in foo.c    
        edit foo.c # or meld foo.c    

-   Once the conflicts are resolved, use git add to tell git that you resolved the conflict

        git add foo.c    
        git status # should now show foo.c as modified in the Changes to be committed:    

-   Use "**git rebase --continue**" to tell git rebase that you have resolved a conflict and want to continue (you don't do this if you used git stash - but it shouldn't hurt, just give you a warning message)

    If you used git commit to save your work in progress, you can use git reset to "undo" your commit

        git reset --soft HEAD^ # go back to WIP state in the working tree    
        git reset # update index too    

-   OR, just do multiple git commits, then use "**git rebase -i**" with the *squash* or *fixup* option to "squash" multiple commits into a single commit.

    See git reset --help, the section about Interrupted workflow for more information.

-   If you used git stash to save your work in progress, note that git stash pop will NOT remove the stash from the stash list if you had to resolve conflicts - you must use git stash drop to do that:

        git stash pop    
        # resolve conflicts    
        git stash drop 'stash@{0}' # stash@{0} is the default if git stash pop is used with no arguments    

    Also note that stashes are "global" - so if you have multiple branches, you must take care to specify the correct stash when using git stash pop or git stash apply - the stash will tell you which branch it was created on, but you must be careful not to pop it or apply it on a different branch.

-    Do not work on the main branch, unless you are staging commits to be pushed to the shared repository.

Commit/Review Messages
----------------------

The commit message (the message you provide with *git commit*) is very important. This message is used to show information about the commit in git log, in various UIs, when requesting a review, and in the bug fix message if fixing a bug. Fortunately, git provides various ways to fix commit messages (e.g. git commit --amend) revert changes (git revert, and others). The first line of the commit message is important, since this will be the summary that is shown when looking at the logs or various UIs. The first line should contain an informative summary of the patch. If this is a bug fix, use something like:

    Ticket #123 - tel syntax should ignore "+()"    

That is, the first line contains the bug number and bug description/summary. If this is not a bug, use something like this:

    Add support for numeric string syntax    

Make sure there is a blank line after this summary and before the next line. This ensures that email, git formatting tools, gitweb, etc. can display the commit information correctly.

The rest of the commit message should contain more detailed information, such as the following:

    Fix Description: - to help the reviewer understand what the new code does    
                       and how it addresses the problem - please be verbose    
    Platforms tested: - e.g. Fedora 11, Solaris 10 64bit, etc.    
    Flag Day: - yes or no - does this change require other developers to do    
                something?  For example, if you change the pblock structure,    
                this will cause almost the entire server code plus plugins    
                to have to be rebuilt    
    diffs - attach files from git format-patch, or links to bug patch attachments if this is a bug fix    

You can add the following headers if they are relevant:

    Branch: - main for trunk or specific maintenance branch - if omitted, main/trunk is assumed    
    Doc impact: - the impact this fix will have on project documentation    
    QA impact: - the impact this fix will have on QA    
                 (e.g. test all replication code)    
    New Tests integrated: - new test plans, test scripts, etc.    

Diffs/Patch files
-----------------

Before you submit patches for review, you should pull the latest changes from upstream and rebase your commits on top of them, to make it easier to integrate your patches with upstream (see above). That is, you should make sure your changes merge smoothly with any changes that have occurred upstream that might conflict with your changes.

Use git format-patch to generate the diffs/patches to submit for review and for pushes. You can attach these files to bugs as patch attachments and the diff tool will show them graphically. The files from git format-patch are used with git-am to merge your patches with upstream. You can think of the output of git format-patch as like an ASCII export of your commits from your local git database, than can be imported back into another git database, preserving all of the git commit information. If you just use git diff, this does not have all of the commit information.

    git commit -a -m "fix for ticket 666 - server eats babies for breakfast"    
    git format-patch HEAD^ # or format-patch -1    

This will generate a file called XXXX-fix-for-something.patch.

-   NOTE: If possible, omit diffs from autotool generated files, such as configure, Makefile.in, aclocal.m4, etc. These generate a lot of noise for reviewers to wade through.
    -   You can use git diff HEAD\^ configure.ac Makefile.am ...otherfiles... \> review.diff

If working on a Trac ticket in 389 in Fedora Hosted e.g. <https://fedorahosted.org/389/ticket/123>, attach the patch file(s) to the ticket as an Attachment using the *Attach file* button. Trac will automatically recognize the file as a patch and will allow you to have a side-by-side view of the patch diffs [Example](https://fedorahosted.org/389/attachment/ticket/456/0001-Ticket-456-improve-entry-cache-sizing.patch).

We don't use bugzilla any more, but if you must use bugzilla to fix a bugzilla bug, attach the patch files to the bug as attachments, and be sure to mark the diff file as a **patch** - this will allow the use of the graphical diff tool in bugzilla. [Example](https://bugzilla.redhat.com/bugzilla/attachment.cgi?id=148985&action=diff)

Code Review
-----------

All patches must be submitted to the developer list for review. This is currently 389-devel@lists.fedoraproject.org. There is an exception to this rule called the "One Liner" rule - if the patch is trivial (e.g. only one line changed), it can be pushed upstream without a review. What means trivial? Use your best judgment.

The review request should have a link to the ticket and a link to the diff/patch. In the ticket, in the *Modify Ticket* section, there is a *Review:* field. The menu for this field has a *review?* item - select this item to mark that you have submitted the patch for review and have requested a review.

We don't use bugzilla any more, but if you must, if submitting a review for a bugzilla bug, in your request email, please include a link to the bug, and a link to the diff. In the field for your Attachment in the main window for your bug, there is a Detail link. Under this, there is a Flags section with a review label and menu button. If you are requesting a review, you do not have to select "?" from the menu, unless you are requesting a review from a specific person.

To review a patch in a ticket, first click on the patch/diff attachment in the ticket. This will bring up a graphical side-by-side view of the patch. If the patch is too big, you can download the patch file to your local workstation and use something like kompare or meld or whatever to view the diffs. To mark the ticket as reviewed, in the ticket, go to the 'Modify Ticket'' section and the *Review:* field. Change the value to *ack* to approve and *nack* to disapprove.

If this is a bugzilla bug, if you click on the Details link for the bug attachment in the main bug window, this will open the Details view of the bug. Under this, there is a Flags section with a review label and menu button. When you review the bug, to make a positive review of a bug, just select the "+" from the menu. To make a negative review, select the "-" from the menu. The "Requestee" will automatically be filled in with your email/username. You do not have to be specifically requested to review a bug - you can just select "+" at any time, even if someone else has already reviewed the bug. There is a Comment field below for further comments.

For bugzilla, in the past, we used the Devel Whiteboard field - *comment\#N.review+id* e.g. **comment\#2.review+rmeggins** to indicate approval, or **comment\#2.review-rmeggins** to indicate a problem with the proposed fix. But since bugzilla upgraded to use the review menu, we no longer use the Devel Whiteboard field. But if you are searching for older bugs, you may want to search on this field.

If submitting a patch not associated with a ticket, just send email the git format-patch file to the devel list. To review a bug, reply (to list) to the review request message with an "ack" and further comments if necessary.

Fixing Review Issues
--------------------

If there are issues with your patch, git allows you to fix your commits.

    git checkout topicbranch # if you're not already in that branch    
    git reset --soft HEAD^ # make the last commit available for editing    
    edit foo.c # make changes    
    git commit -a -c ORIG_HEAD # this will also allow you to edit the commit message    

If you just want to edit the commit message for the last commit

    git commit --amend    

See "**git reset --help**" for more information

You can also use "**git rebase -i**" to "squash" or combine several commits into one commit.

Working with Multiple Release Branches
--------------------------------------

At any given time, 389 will have one or more releases being supported, each with its own branch. For example, the 1.2.11 releases use the 389-ds-base-1.2.11 branch in git. At some point you will need to apply a patch to main and one or more of these release branches. It is still a good idea to work on a branch off of main and apply the patches in main branch, then cherry-pick your changes to the other release branches.

    git checkout -b 389-ds-base-VERSION # get the branch    
    git cherry-pick -e -x main # assumes you have just merged your commit with main    

OR

    git cherry-pick -e -x COMMITID # you can cherry-pick any old commit id    

If the cherry-pick fails, you will need to fix the conflicts:

    git status # show which files are in conflict    

cherry-pick will leave the usual \<\<\<\<\<\< ===== \>\>\>\>\>\> markers in the file showing you the changes that came from main and the changes that came from the release branch. Edit the files to fix the conflicts

    git mergetool # graphical diff/edit tool    

OR

    edit file1 file2 .... # edit each conflicted file with your favorite editor    

Add the files to resolve the conflicts and commit

    git add file1 file2 .... # git add each file to tell git you fixed it    
    git commit -c main # or COMMITID if you gave a specific commit id    

If you have multiple commits to cherry-pick, you'll have to do them one at a time, in order from earliest to latest:

    for cm in firstcommit secondcommit ... lastcommit ; do    
      git cherry-pick -e -x $cm || { echo error - commit $cm has conflicts ; break ; }    
    done    

Pushing Upstream
----------------

First, make sure you are in the correct branch that you want to apply/commit to:

    git branch # list my current branch    
    git checkout main # to switch to the current branch    

Next, make sure that branch is up-to-date.

    git pull    

If changes were pulled in, rebase your working branch off of main and resolve any conflicts.

    git checkout <workbranch>
    git rebase main    

Switch back to the main branch (or the remote branch you want to push to)and merge in your changes from the working branch.

    git checkout main    
    git merge <workbranch>

The merge should be clean, and no merge commit should appear when running *git log -1*. You can now push the commits to the remote repository.

    git push <repo> [<branch>]
    # for example    
    git push origin 389-ds-base-1.3.0    

By default, git push will push **all** local branches to the upstream repo. Specify the branch to push only changes to that branch.

Use **git am** to "import" commits into your local tree from patch files created with git format-patch.

Once the push has been done, the git upstream server will send out a commit email to **389-commits@lists.fedoraproject.org**.

Update the Ticket
-----------------

If fixing a ticket, once the patch has been committed and pushed to upstream, update the ticket. The ticket fix comment should include the commit hash. Trac will automatically recognize the commit hash and create a link to the commit in the source viewer in trac. NOTE: you must use the full 40 character hash, not the short 7 character hash. It's easy to just copy/paste the git commit header e.g.

    commit 97ef3ddcb09a5cf7e17a77282295bf5634c45f3b    
    Author: Rich Megginson <rmeggins@redhat.com>
    Date: Fri Jun 1 17:26:34 2012 -0600    

Since the commit has the fix description and other details in it, there is no need to include this information in the trac ticket.

NOTE: If this is a commit to a repo other than 389-ds-base, you must include *changeset:* and the repo name e.g.

    commit changeset:97ef3ddcb09a5cf7e17a77282295bf5634c45f3b/389-admin    
    Author: Rich Megginson <rmeggins@redhat.com>
    Date: Fri Jun 1 17:26:34 2012 -0600    

Otherwise, trac will attempt to link the commit to the 389-ds-base repo and will fail.

In the *Modify Ticket* *Action* section, mark the bug as *resolve as fixed*.

If fixing a bug, once the patch has been accepted and committed to upstream, update the bug. The bug fix comment should include the fix description (not the bug description) - you are encouraged to use the original commit message, reviewer (if not specified in the Devel Whiteboard field), list of files affected (if not in the patch), and the commit hash. The commit hash allows us to go back to the code and find the original commit for this bug, and identify any tags or branches associated with the commit. Change the state of the bug to the appropriate state (we are currently using MODIFIED to indicate the bug has been fixed and requires QA).

