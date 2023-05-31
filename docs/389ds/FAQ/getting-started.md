---
title: "Getting started"
---

{% include toc.md %}

# Starting with 389 Directory Server
------------------------------------

A Directory Server is a type of database often used to centrally store data about people. It is best
used for data that does not change often but is read frequently such as email addresses and other
contact information; passwords and certificates; and any relatively static business data. It is
really useful when you have a variety of clients that can talk to it. There is quite a bit of client
software available for the Directory Server. The list of client software is available on our
[client software](client-software.html) page.

### Community Support

As open source software, there are many ways to get help. This includes online
[documentation](../documentation.html), support provided by the project developers and community in the
mailing lists and online chat sites in IRC.

You can keep up with the goings-on of the project in our [mailing lists](../mailing-lists.html).

You can talk to other users in real time by joining the \#389 channel on the IRC server irc.libera.chat.

If you are new to LDAP Directory servers you may want to read an overview of the Directory Server
[architecture](../design/architecture.html). This will introduce you to a lot of the technology and
terminology behind an LDAP server.

# Getting the 389 Directory Server software
-------------------------------------------

#### Download

You can download pre-built copies of the 389 Directory Server for your platform. It's available for
many different operating systems in quite a few formats. Please check our [download](../download.html)
page for more instructions on how to download binaries for your system.

#### Build

Building the 389 Directory Server is a really painless process, and we have done our best to make
contributing as easy as possible. The instructions on how to build it for your platform can be found
on our [building](../development/building.html) page.

### Setup an instance
---------------------

Installing an instance is designed to be fast and easy. You can follow our instructions on our
[install page.](../howto/howto-install-389.html)


### What next?
--------------

#### Managing users and groups

An LDAP instance is classically used to store users and groups. We supply many tools to help
make this process easier, and you can [learn more about them](../howto/howto-users-and-groups.html)

#### Deploy TLS

Transport encryption protects your passwords and identities on the wire, so you should setup
TLS by following our [TLS guide](../howto/howto-ssl.html)

#### Configure clients to use 389DS

A large use case of LDAP is to allow your linux servers and workstations to authenticate. You can
follow our [SSSD guide](../howto/howto-sssd.html)

#### What the Directory Server Can Do

389 Directory Server has many features. To read more about them, our [features page](features.html) contains
a lot of information to help you.

#### Documentation

There's a huge amount of reference material available for the Directory Server. You might want to
look at our [documentation](../documentation.html) page for information if you know exactly what you're
looking for.

#### Integrating the Directory Server with your Software

A Directory Server is not a valuable piece of software in and of itself. It's importance is only revealed
in how other pieces of software use it. Whether it's a mail client or a multi-thousand machine data
center, you have to know how to make the best use of the Directory Server with your software. You
might want to visit our page on using the Directory Server. It contains information on how to use
DS from the perspective of a [client](client-software.html), or if you're interested in writing
plugins for the Directory Server, you might want to see our page on building Directory Server
[plugins](../design/plugins.html). Our [documentation](../documentation.html) page contains a more
complete list of software-related materials available.

### Contributing to the project
-------------------------------

The 389 Directory Server Project is an open source project. This means that we would hope that -
whether or a you're a user or a developer - you will contribute back to the project. There are quite
a few ways that you can do this. Send us feedback on your install experience and what was easy, hard
or confusing. We always want to improve this! Did you find something you wish you could do with
our command line tools? Maybe a feature you wish was possible? Contact us, so we can help you
get started with [development](../contributing.html). We are always willing to mentor and help new
contributors.

### The Future

To see the direction the project is going in, check out our [roadmap](roadmap.html).

Our current [wishlist](wishlist.html) is also available.

