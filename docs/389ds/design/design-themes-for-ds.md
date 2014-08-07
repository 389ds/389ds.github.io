---
title: "Design Themes for DS"
---

# Design Themes for DS
----------------------

Two major design directions we could take with DS (or both!):

1.  <b>Refocus DS on one of the goals for which LDAP is already recognized</b> (see below)
    1.  Drop-in NIS replacement
    2.  Drop-in single-sign on + phonebook

2.  <b>Expand the set of goals for which LDAP is recognized</b>
    1.  Why not use directories for many technical development tasks where they're better suited than RDBs (e.g. Flickr)?
    2.  "Make a large company function like a small office"

Are there other design directions?

## On the Marketing and Use of LDAP Servers

What does a directory server do? Its just a way to store and retrieve information. This is not a user task, per se, except perhaps in the most general sense.

On the Marketing of Goals
-------------------------

Raw technology is formless. While it may be fit for a variety of purposes, it only becomes interesting when applied; when use is imparted to it, when it is laden to a task. There are simply too many technologies around us to pay attention to all of them, let alone explore their potential.

A great example of this is the conglomeration of technologies referred to as "AJAX". AJAX is curious because it is distinctly <i>not</i> a technology, but is instead a label applied to a particular <b>tasking of technology</b>. The various components of AJAX (javascript, xmlhttprequest, xhtml, server-side logic, etc) existed for a long time before the world as a whole mixed them together. In many ways it was not even just the mix of technologies that was the "new" (of course, not truly unprecedented, but having it as a widespread thing that people found engagement with), but the goal itself that was new: making instantly responsive "rich" applications on the web.

Additionally, most people are relatively unattuned to the problems that exist. Most people live happily with a great many inconveniences and problems (some directly brought about by faulty technology, and some inherent but solvable through technology) without explicitly recognizing them "from primary sources", as it were. Instead, <b>people scavenge for goals</b> that may be interesting to accomplish, and then use technology that suggests itself for that goal. People scavenge for goals even more frequently than they scavenge for technology. That is one of the reasons that great multitudes of organizations end up targeting the same problems at the same time, many times problems that have been endemic for years. They didn't directly recognize the problems as interesting things to tackle (by technology or otherwise) until it was indirectly pointed out to them.

One of the major places that Apple "innovates" is not in the technology-space, per se, but even more deeply in the goal-space. Apple serves as an engine that, through its public recognition, media savvy, and skill of execution, can take not-widely-known goals and promote them to the extent that people are interested in them. Sometimes, perhaps, Apple discovers new goals. But as often as not, good design simply requires filtering through the thousands of goals that people already know about and picking one to really sell to people.

Single Sign-On as an Example
----------------------------

A great example of this that is very near and dear to the heart of LDAP is single sign-on. Single sign-on is <i>not a technology</i>, it is a goal. That there is widespread interest in single sign-on is not merely because it is a problem that afflicts users and IT, but even more so because its a goal that bubbled up to receive public attention and dissemination. LDAP was successfully posited and similarly disseminated as a solution to that problem. In fact, the two were historically so closely coupled (though now there are other alternative approaches to the goal) that you could say that LDAP sold itself through the goal. Every time single sign-on was promoted as a goal, LDAP was promoted as a technology indirectly (and yet more powerfully than if LDAP had merely been directly promoted).

## LDAP's Goals

Early directory servers billed themselves (at least, based on what I read in [the LDAP Bible](http://safari.awprofessional.com/0672323168)) primarily as a "phonebook replacement" and as a "NIS replacement. More recently (though still a long time ago), LDAP servers have acquired the goal of "single sign-on".

So here are the goals for which LDAP is currently marketed:

-   logging into servers (/ workstations)
-   using a single password & username to login to all computer network services
-   phonebook replacement

What's notable is that (despite the relative generality of LDAP servers) the list of goals, at a publicly visible level for sysadmins, hasn't significantly expanded since early in the inception of LDAP servers.

Databases and the Natural Expansion of Goals
--------------------------------------------

Contrast this with databases, which started with a similarly narrow focus, but have expanded the conception of "what they're good for" massively. Of course, this didn't entirely (or even primarily) occur as a result of intentional marketing on the part of, say, Oracle, but instead because the database was adopted as the de facto data storage tool of choice for the web.

## Where to Head

An interesting point is that the goals of LDAP server developers may now be significantly divergent from the publicly disseminated goals. Reconnecting these two may actually provide a significant competitive advantage for the first product to do it. In my experience LDAP server developers think of LDAP in terms of these goals:

-   a massively scalable storage mechanism for small bits of information that are read more than they are written (but is pretty damn scalable for writing too... ;-)

We can rephrase the two categories of designs in these terms:

1.  Designs that <b>contract the focus of LDAP server developers to match their users narrow existing goals</b>
2.  Designs that <b>expand the goals of users to match the more general goals of LDAP server developers</b>


