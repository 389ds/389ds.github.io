---
title: "Onlinehelp"
---

# Online Help
-------------

The core console and admin server on-line help HTML pages are now open source and have been released under the terms of the [Open Publications License](http://opencontent.org/openpub/). These files are currently used as part of the [AdminServer](../administration/adminserver.html) build process.

### Please Help!

These files were originally generated from FrameMaker sources but have since become out of sync due to manual editing of the HTML. We are in the process of converting all of our source documents to [DocBook](http://www.docbook.org/) format, so that we can more easily edit them and convert them to other document formats. There is a tool called [html2db](http://www.michael-a-fuchs.de/projects/dbdoclet/en/html2db.html) that can be used for the conversion.

### Pulling the Source

For anonymous access, use

`CVSROOT=:pserver:anonymous@cvs.fedora.redhat.com:/cvs/dirsec ; export CVSROOT`
`cvs login`

(password is empty i.e. just press Enter or Return)

If you have commit access, use

`CVSROOT=:ext:yourlogin@cvs.fedora.redhat.com:/cvs/dirsec ; export CVSROOT`

You will have to apply for commit access - see our [contributing](../development/contributing.html) page on more information on how to get CVS commit access.

OK, you're ready to pull the source. Do it!

`cvs -z3 co [-r RELEASETAG] onlinehelp`

The current release tag is FedoraDirSvr103. See [AdminServer](../administration/adminserver.html) for instructions about where to checkout the files.
