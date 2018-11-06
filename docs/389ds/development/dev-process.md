---
title: "Directory Server Development Team Process"
---

# Directory Server Development Team Process
------------------------------------

{% include toc.md %}

## Introduction

This doc is an attempt to describe the work-flow for the DS development team. It does not cover everything, but it describes the basics of the day to day tasks and prioritizations developers should be following.  This process is really a *work in progress* and can/will change in the future, but for now this is what we got...

<br>

## The Team Goal

*Release updated versions of Directory Server containing customer fixes/RFE's in RHEL*

What does this mean?  It means that customer bugs/RFE's should be the first priority over all other development tasks.   We need to focus on the bugzillas that have been triaged (dev acked) for various RHEL releases and batch updates.

<br>

## Prioritizing Work

Of course hot customer bugs need to be addressed first, and should always be the number 1 priority.  We all need to work on and distribute customer cases among the team members so not any one person gets overwhelmed.  We also need to keep the open source community happy by fixing issues they find as well.  In most cases these are also bugs that RHEL customers could potentially run into, but haven't yet.  So we need to look into these issues as well.  Finally, we have product enhancement (aka new features) - this is the fun stuff :-)  Most new features go into major releases: RHEL 7.6 or 7.7, but they do not typically go into batch updates (e.g. 7.6.z).  And as for new features, customer RFE's take precedence over upstream/community RFE's.

So how do we prioritize all of this?  As previously stated customer escalations come first.  After that we still need to focus on customer RFE's and bugs that have been triaged into various RHEL releases.  You should use the "ack viewer" found on the DS/QE Sync-Up Etherpad to keep track of what we should be working on for the next RHEL releases.  So how does community/upstream fit into this?  If we feel like a upstream ticket is worthy of being in RHEL release, then we need to clone that ticket to Bugzilla where it can be triaged into an appropriate RHEL release.  All tickets eventually need to have a Bugzilla if they are to be released in RHEL/downstream (there are a few exceptions but don't worry about that right now).

<br>

## Balancing Work

In an ideal world we could sit down and work on a new feature without any distractions until it is complete, but we do not live in that world.  If you are working on a big RFE/feature, you still need to help out with other bugs and customers issues at the same time, and visa versa, you shouldn't be completely stuck on customer issues either, as there are other bugs that need fixing at the same time.  You must multi-task, and share the workload among the team.

<br>

## The Team Process

Here is the basic process you should follow:

- Need something to do?  Start working on a bug/RFE from the ack viewer (that has the QE/Dev acks) for the next release of RHEL.
- Keep an eye out for customer bugs as they come in.  You should be acked on all DS bugs.  If not, let me know.  Assign one of these bugs to yourself if you are not already working on a HOT customer bug.  It is common to have many customer bugs assigned to yourself.  You're not expected to update them every day, but they must be divided up.  Right now we use the honor system to self assign bugs, but you might also be assigned bugs by the team lead.  Hopefully we keep using the honor system, but if it doesn't we'll have to do a more formal triage.
- RHEL deadlines - as a deadline approaches you need to focus on bugs for that upcoming release (they are usually customers bugs anyway)
- Post RHEL releases - this is when we have free time to work on upstream tickets and other RFE work (design, triage, etc).

<br>

## Other processes

Here are some other processes we use for our various responsibilities

### Bugzilla State Flow

1. NEW - No one is working on the bug
2. ASSIGNED - The bug is assigned and someone is looking into it
3. POST - The bug is fixed in the upstream code (master branch)
4. MODIFIED - the bug is now fixed in a RHEL/brew build (this is done by the person who does the RHEL build)
5. ON_QA - The QE team is in the process of verifying the bug fix (this is typically done automatically by the errata tool).

<br>

### The Downstream Process

1. Investigate bug and determine if it's valid and that there is enough information to properly work on it.
2. If there is a bug that should be fixed then clone the Bugzilla to a upstream ticket (<https://ipatool.idm.lab.bos.redhat.com/>)
3. All technical work should be recorded in the ticket, and only customer/QE/GSS interaction should be in the Bugzilla.
4. Follow the *Upstream Process* below to complete the work on the ticket

<br>

### The Upstream Process

1. Review tickets/issues in a milestone that is slated for the next RHEL release
2. If it is a bug, and you think it should be fixed then the ticket should be cloned to a Bugzilla (<https://ipatool.idm.lab.bos.redhat.com/>) - don't forget to assign the new bug to yourself.
3. Develop the fix and CI test
4. Merge fix after it's reviewed and approved.  Also check it into other branches where it might be needed
5. Change the Bugzilla state to POST - this means the fix has been checked into the source code
6. Close the ticket.

<br>

### RFE Development Process

This is an area that needs some refinement/structure.  But basically you should be writing up a design doc on the wiki before you write code. See these links

[The Design Doc Homepage](https://www.port389.org/docs/389ds/design/design.html)

[The Design Doc Template](https://www.port389.org/docs/389ds/design/design-template.html)

Then it can be discussed before any major work is done.  We haven't followed this model strictly in the past, but we should try and follow it moving forward.

<br>

## Keep in mind..

Here is a list of things to keep in mind as you work on bugs

- You should be writing lib389 test cases (where applicable).  Ideally create a test to reproduce the problem first, not after you fix it.
- QE is only aware of Bugzillas!  Do not assume they look at tickets (nor should they have to).  Bugzillas are what drive the downstream/RHEL releases
- If you are working on a ticket that has a Bugzilla you need to assign that Bugzilla to yourself!
- Bugzilla Doc Text - **please please please** fill out the Doc Text in the Bugzilla when you fix a bug.  We all need to work on this, but it's not fair to the Doc team for them to have to constantly ask us to fill this out.  We should be doing it when our bug goes into POST.







