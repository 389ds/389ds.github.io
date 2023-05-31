---
title: "DSML Gateway Design"
---

# DSML Gateway Design
---------------------

{% include toc.md %}

Background
==========

[DSML v2.0](http://xml.coverpages.org/DSMLv2-draft14.pdf) is a Web Services protocol that closely mirrors LDAP. DSMLv2 is designed to allow arbitrary Web Services clients to access Directory Services using the client's native protocols (SOAP over HTTP). DSMLv2 allows content stored in a Directory Service to be easily accessed by standard off-the-shelf Web Service applications and development tools, removing the need for application developers to use and understand one of the LDAP SDK libraries.

Requirements
============

A DSML V2.0 service must be implemented to work in conjunction with the Directory Server versions 7.1/1.0 and later. On-the-wire interoperability must be demonstrated with DSML clients from other vendors.

Implementation
==============

The DSML V2.0 service will be implemented in Java as a gateway. The plan is to resurrect an old Java DSML gateway implementation from an abandoned development project. This code was written at a time when Java Web Services APIs and implementations were not mature. Today there are new APIs and readily available free implementations. Therefore the bulk of the work to be done involves re-writing the older code to make it compatible with the current JAX-RPC API and integration with the present-day server container products.

Implementation as a gateway (as opposed to natively within the Directory Server) offers the following benefits:

-   Reduced development risk (DSML code can't destabilize the server).
-   Improved throughput (XML parsing, which is CPU-intensive, can be done on a different CPU than the server uses).
-   Integration with emerging Web Services Protocols (for example WS-Security) can be added without further directory server code bloat.
-   If needed, release schedule can be decoupled from that of the server.

The gateway architecture will however increase response times slightly in relation to a native Directory Server implementation because each request must be forwarded through the gateway.

Implementation in Java offers the following benefits:

-   Execution in a wide range of Operating System and CPU environments, including those that are not supported for the Directory Server.
-   Leverage of existing Java Web Services implementations that are typically licensed at no charge.

Execution Environment
=====================

The gateway will run within a Java Web Services server environment. Specifically this means an environment that provides an implementation of the JAX-RPC API. Examples include Apache Axis, Sun's Reference Implementation (WSDP) and Systinet's Java Web Services. Customers will be able to deploy the gateway within the execution environment of their choice, but for convenience the gateway will ship with Apache Axis. Installation will be easy even for customers that are not experienced in Java Web Services.

Interoperability Testing
========================

During the development phase of the project, the gateway must pass interoperability tests against the following 3rd party DSML v2.0 implementations:

-   Sun's [DSRK client tools](http://docs.sun.com/source/816-6400-10/dsmltools.html).
-   Novell's [example client](http://developer.novell.com/dsml/).

Functional Testing
==================

The gateway functional tests must provide:

-   100% gateway code coverage.
-   Testing for all LDAP operation types.
-   Tests that exercise concurrency in the gateway.
-   Tests that exercise scaling limits in the gateway (number of concurrent connections and so on).

