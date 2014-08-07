---
title: "Licensing"
---

# Licensing
-----------

{% include toc.md %} 

Overview
--------

Licensing determines what rights you have to use this software in both binary and source form. The Fedora Directory Server is made up of a number of different pieces of software, each with their own licensing. Each of these licenses is described below. And we must say, of course, that this document should not be taken as legal advice. Talk to your attorney.

<a name="client"></a>

Client Library Licensing
------------------------

The client library that we suggest you use is the LDAP SDK from mozilla.org. This library is available under an MPL/LGPL/GPL tri-license. More information about the MPL can be found on the [mozilla.org pages on the subject](http://www.mozilla.org/MPL/).

Most people who are using the Directory Server instead of working on the code directly will be able to build clients under a variety of different licenses, including many open source licenses or proprietary licensing. The MPL is a copyleft license, but works largely at the file level instead of at the program level. To try to sum up the license in a single sentence, it requires that you make changes available to files covered under the MPL, but it does not require that code linked to the MPLed code also be made available under the MPL. Once again, please see the [MPL](http://www.mozilla.org/MPL/) pages for more information and details.

Directory Server Licensing
--------------------------

The Fedora Directory Server is made up a few different pieces of code. These include:

### Directory Server Core

This is the bulk of the code. This is available under a "GPL Exception" license created for this project. You can read the license on the [license text](../development/gpl-exception-license-text.html) page or get more information on the [annotated license text](annotated-gpl-exception-license.html) page.

### Admin Server and Management Console

The admin server and management console are components used to manage the Directory Server once it's been installed. They are licensed under the GPL.

### mod\_nss, mod\_admserv, and mod\_restartd

These are Apache modules used by the Admin Server. They are licensed under the [Apache 2.0 license](http://www.apache.org/licenses/).

### NSPR / DBM / NSS / SVRCORE / LDAPSDK / PerLDAP

Since these come from mozilla.org, this code is licensed under an MPL/LGPL/GPL tri-license. See the information in [Client Library Licensing](licensing.html#client) on the MPL.

### Cyrus SASL

Cyrus SASL is covered by its own license which allows use as long as several rules are followed. See COPYING in the source distribution available from [<ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/>](ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/)

### Berkeley DB

Sleepycat Software, the maker of Berkeley DB, permits their library to be used under the "condition that if you use the software in an application you redistribute, the complete source code for your application must be available and freely redistributable under reasonable conditions." See [<http://www.oracle.com/technology/software/products/berkeley-db/htdocs/licensing.html>](http://www.oracle.com/technology/software/products/berkeley-db/htdocs/licensing.html) for the full license.

### International Components for Unicode

The ICU project is licensed under the X License (see also the [x.org](http://www.x.org/Downloads_terms.html) original), which is compatible with GPL but non-copyleft.

The license allows ICU to be incorporated into a wide variety of software projects using the GPL license. The X license is compatible with the GPL, while also allowing ICU to be incorporated into non-open source products. The full ICU license can be found [here](http://source.icu-project.org/repos/icu/icu/trunk/license.html).

### Net-SNMP

Net-SNMP is covered by several licenses, all BSD or BSD-like. See the Net-SNMP [license page](http://net-snmp.sourceforge.net/about/license.html) for full details.

Directory Server Plugin Licensing
---------------------------------

Through the exception that we've made available in our licensing terms it should be possible to build plugins under any license you choose, assuming that you stick within the limits of the exception. Please see the [annotated license text](annotated-gpl-exception-license.html) page for more information.

