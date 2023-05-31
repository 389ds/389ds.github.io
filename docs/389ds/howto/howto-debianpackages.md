---
title: "Howto: DebianPackages"
---

# Debian Packages
------------------

To build the Debian packages I'm maintaining a set of scripts developed by Ryan Braun. They work very fine.

The scripts are here: <https://github.com/diegows/389DS-debian>

Procedure
---------

1.  git clone <https://github.com/diegows/389DS-debian>
2.  cd 389DS-debian
3.  find -name 'build\*. On every file founded by find, modify the variable VERSION to match the current version of the packages in [389 DS Download directory]({{ site.binaries_url }}/binaries/). Look the line executing wget if you don't know what the name of the tgz file is. The buildconsole file has the VERSION variable in several places.
4.  Now change to every directory and execute the build\* script in the following order: svrcore, mod\_nss, mozldap, perldap, port389-ds, port389-adminutil, port389-admin, console. You must install the packages after they are built because there are dependencies between them.

The scripts will ask you to install the required dependencies.

I tested this script in Debian Squeeze and works. I agree that they need to be improved :)

Feedback and bug reports and welcome.
