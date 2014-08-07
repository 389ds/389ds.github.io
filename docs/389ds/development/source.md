---
title: "Source"
---

# Directory Server Source Code
------------------------------

{% include toc.md %}

These are the sources used by the directory server which are provided by the project (as opposed to third party sources like the Mozilla components, berkeley db, etc.).

[All the source tarballs]({{ site.baseurl }}/binaries/)

All of the source is now in git. The git module given below is a sub-directory of the base git URL **git://git.fedorahosted.org/389/** - so for the base directory server, the full git URL is **git://git.fedorahosted.org/389/ds.git**

The idm-console-framework is not under 389/ it is at **git://git.fedorahosted.org/idm-console-framework.git**

The source code was produced by first doing a git clone to get the repository, then a git archive to produce the source tarball

    git clone git://git.fedorahosted.org/389/MODULENAME
    git archive --prefix=PKGNAME/ TAG | bzip2 > PKGNAME.tar.bz2

### 389 Directory Server 1.3.2

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.3.2 (branched 1-OCT-2013)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.2.16.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.3.2.16.tar.bz2)|ds.git|389-ds-base-1.3.2.16|[Building](building.html)|95572e2e132d0d313c9ce9f04409f852103210a6|
|[389-dsgw-1.1.11.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.11.tar.bz2)|dsgw.git|389-dsgw-1.1.11|[DSGW\_Building](../administration/dsgw-building.html)|22cddf8c52a6178c047ff0c0f1f34768e5165dfd|
|[389-adminutil-1.1.20.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.20.tar.bz2)|adminutil.git|389-adminutil-1.1.20|[AdminUtil](../administration/adminutil.html)|0cfc121a07959c6952751404bf5bc495f6fe1155|

### 389 Directory Server 1.3.1

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.3.1 (branched 13-FEB-2013)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.1.22.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.3.1.22.tar.bz2)|ds.git|389-ds-base-1.3.1.22|[Building](building.html)|671536bc70633e802b401c69d76da06e09e04ae0|
|[389-adminutil-1.1.18.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.18.tar.bz2)|adminutil.git|389-adminutil-1.1.18|[AdminUtil](../administration/adminutil.html)|054a9e06e91e1e0d8f88903cbcf8e7ab8b270589|

### 389 Directory Server 1.3.0

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.3.0 (branched 11-DEC-2012)

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.3.0.9.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.3.0.9.tar.bz2)|ds.git|389-ds-base-1.3.0.9|[Building](building.html)|45d9ccdaac75e7702de68d0972a27d39fefc67e9|
|[389-ds-base-1.3.0.3.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.3.0.3.tar.bz2)|ds.git|389-ds-base-1.3.0.3|[Building](building.html)|39f2b96bd6d6760af07780157efecc661d0e88c0|
|[389-admin-1.1.31.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.31.tar.bz2)|admin.git|389-admin-1.1.31|[AdminServer](../administration/adminserver.html)|bbfc6313db39bb55fa1cbd03fca8fffdcff286ae|
|[389-adminutil-1.1.18.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.18.tar.bz2)|adminutil.git|389-adminutil-1.1.18|[AdminUtil](../administration/adminutil.html)|054a9e06e91e1e0d8f88903cbcf8e7ab8b270589|
|[389-dsgw-1.1.10.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.10.tar.bz2)|dsgw.git|389-dsgw-1.1.10|[DSGW\_Building](../administration/dsgw-building.html)|f147769e82187b570eb3e39b3a9fb1572bdd4512|
|[winsync-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html)|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.7.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.7.tar.bz2)|ds-console.git|389-ds-console-1.2.7|[DirectoryConsole](buildingconsole.html#ds-console)|21ed7ce7b2a2c0a529d251bbd33435d60a93a4fa|
|[389-admin-console-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.11

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.2.11

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.11.29.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.11.29.tar.bz2)|ds.git|389-ds-base-1.2.11.29|[Building](building.html)|ad392648f8dfa66c8a6d9d6843e1d10a3d518ae6|
|[389-admin-1.1.30.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.30.tar.bz2)|admin.git|389-admin-1.1.30|[AdminServer](../administration/adminserver.html)|971fb47a5d97cd32b6820f0f4cb99c196165dd0f|
|[389-adminutil-1.1.15.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.15.tar.bz2)|adminutil.git|389-adminutil-1.1.15|[AdminUtil](../administration/adminutil.html)|bbf4219b55bb1af0a76bb75bb16af4121b36f4de|
|[389-dsgw-1.1.10.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.10.tar.bz2)|dsgw.git|389-dsgw-1.1.10|[DSGW\_Building](../administration/dsgw-building.html)|f147769e82187b570eb3e39b3a9fb1572bdd4512|
|[winsync-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.6.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.6.tar.bz2)|ds-console.git|389-ds-console-1.2.6|[DirectoryConsole](buildingconsole.html#ds-console)|adc763187f6b2e7f9f347b930276ab5712eb7807|
|[389-admin-console-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.10

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.2.10

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.10.14.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.10.14.tar.bz2)|ds.git|389-ds-base-1.2.10.14|[Building](building.html)|8de0e6c9d77041d48927200c42f5400645672db1|
|[389-admin-1.1.29.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.29.tar.bz2)|admin.git|389-admin-1.1.29|[AdminServer](../administration/adminserver.html)|6cdb023dadd0862327fd09f06f6a51454ff8672c|
|[389-adminutil-1.1.15.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.14.tar.bz2)|adminutil.git|389-adminutil-1.1.15|[AdminUtil](../administration/adminutil.html)|bbf4219b55bb1af0a76bb75bb16af4121b36f4de|
|[389-dsgw-1.1.9.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.9.tar.bz2)|dsgw.git|389-dsgw-1.1.9|[DSGW\_Building](../administration/dsgw-building.html)|8bf25eeda80ec9fb15c53564dbaa32e5d2c7deff|
|[winsync-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto-windowssync.html)|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.6.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.6.tar.bz2)|ds-console.git|389-ds-console-1.2.6|[DirectoryConsole](buildingconsole.html#ds-console)|adc763187f6b2e7f9f347b930276ab5712eb7807|
|[389-admin-console-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.9

389-ds-base uses git repo 389/ds.git branch 389-ds-base-1.2.9

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.9.9.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.9.9.tar.bz2)|ds.git|389-ds-base-1.2.9.9|[Building](building.html)|d61a7284eafe5984a38e332445049d15679ed14e|
|[389-admin-1.1.23.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.23.tar.bz2)|admin.git|389-admin-1.1.23|[AdminServer](../administration/adminserver.html)|b3013f3ce833f5dae8ec33f881f46a064f4d1d3d|
|[389-adminutil-1.1.14.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.14.tar.bz2)|adminutil.git|389-adminutil-1.1.14|[AdminUtil](../administration/adminutil.html)|b6af0f12cdeda2d1188a6c6c1d7851da60ad4331|
|[389-dsgw-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.7.tar.bz2)|dsgw.git|389-dsgw-1.1.7|[DSGW\_Building](../administration/dsgw-building.html)|0eb4e05d7ae763395a9338b0a76f441be51612e7|
|[winsync-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.7.tar.bz2)|console.git|389-console-1.1.7|[WindowsSync](../howto/howto-windowsconsole.html|87ae48c131b2964f9dac97e011a8a8fb61d3a8a4|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.7.tar.bz2)|idm-console-framework.git|idm-console-framework-1.1.7|[buildingconsole.html](buildingconsole.html)|2081dea597c2fe0078a8a8f4047884cb1e02e470|
|[389-ds-console-1.2.6.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.6.tar.bz2)|ds-console.git|389-ds-console-1.2.6|[DirectoryConsole](buildingconsole.html#ds-console)|adc763187f6b2e7f9f347b930276ab5712eb7807|
|[389-admin-console-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.8.tar.bz2)|admin-console.git|389-admin-console-1.1.8|[AdminConsole](buildingconsole.html#admin-console)|8e093715b215e64ae9b307bc96df55d2bd496da8|

### 389 Directory Server 1.2.8

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.8.3.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.8.3.tar.bz2)|ds.git|389-ds-base-1.2.8.3|[Building](building.html)|87f1f8ec0044f4b1766b2b65b34f4e14d9d0d41d|
|[389-admin-1.1.16.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.16.tar.bz2)|admin.git|389-admin-1.1.16|[AdminServer](../administration/adminserver.html)|e2facc231d1475b218321b7dbdb04d8f9b6ebacb|
|[389-adminutil-1.1.13.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.13.tar.bz2)|adminutil.git|389-adminutil-1.1.13|[AdminUtil](../administration/adminutil.html)|1de90fc408b0046aeb346fad7e2251f10e07024a|
|[389-dsgw-1.1.6.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.6.tar.bz2)|dsgw.git|389-dsgw-1.1.6|[DSGW\_Building](../administration/dsgw-building.html)|2e18c7b3ccb7c98b68917538c2a75eb445b734db|
|[winsync-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.6.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.6.tar.bz2)|console.git|389-console-1.1.6|[WindowsSync](../howto/howto-windowsconsole.html|06f7128bc86d1429c6fd0a920ecbb0bac9799206|
|[idm-console-framework-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.7.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_7(CVS)|[buildingconsole.html](buildingconsole.html)|f64814028eb4abc8d7fadac794d52f1b9d32de99|
|[389-ds-console-1.2.5.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.5.tar.bz2)|ds-console.git|389-ds-console-1.2.5|[DirectoryConsole](buildingconsole.html#ds-console)|d3eafbec8e7b71f05baa3a9e64ba31692ed6daf8|
|[389-admin-console-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.7.tar.bz2)|admin-console.git|389-admin-console-1.1.7|[AdminConsole](buildingconsole.html#admin-console)|917db7c8b6f4390cbe688966826ac499d6d6cd75|

### 389 Directory Server 1.2.7

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.7.5.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.7.5.tar.bz2)|ds.git|389-ds-base-1.2.7.5|[Building](building.html)|5277c8b26ab45c4399a836de4c4c0294b6b4de2b|
|[389-admin-1.1.14.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.14.tar.bz2)|admin.git|389-admin-1.1.14|[AdminServer](../administration/adminserver.html)|8379b955de459e0efcb1207f8da0881fcd6d9964|
|[389-adminutil-1.1.13.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.13.tar.bz2)|adminutil.git|389-adminutil-1.1.13|[AdminUtil](../administration/adminutil.html)|1de90fc408b0046aeb346fad7e2251f10e07024a|
|[389-dsgw-1.1.6.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.6.tar.bz2)|dsgw.git|389-dsgw-1.1.6|[DSGW\_Building](../administration/dsgw-building.html)|2e18c7b3ccb7c98b68917538c2a75eb445b734db|
|[winsync-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.6.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.6.tar.bz2)|console.git|389-console-1.1.6|[WindowsSync](../howto/howto-windowsconsole.html|06f7128bc86d1429c6fd0a920ecbb0bac9799206|
|[idm-console-framework-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.5.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_5(CVS)|[buildingconsole.html](buildingconsole.html)|15f1d2af4cac986c6caad39f4ed02191169fcb42|
|[389-ds-console-1.2.3.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.3.tar.bz2)|ds-console.git|389-ds-console-1.2.3|[DirectoryConsole](buildingconsole.html#ds-console)|9d433a142a92c7b6a2cc46927dba4140da05810b|
|[389-admin-console-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.5.tar.bz2)|admin-console.git|389-admin-console-1.1.5|[AdminConsole](buildingconsole.html#admin-console)|3baf33f3a045fafb6cd7157e448c9b8453f86721|

### 389 Directory Server 1.2.6.1

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.6.1.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.6.1.tar.bz2)|ds.git|389-ds-base-1.2.6.1|[Building](building.html)|06e84397f93be1fd39bff4eeba981c67d456c6a4|
|[389-admin-1.1.11.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.11.tar.bz2)|admin.git|389-admin-1.1.11|[AdminServer](../administration/adminserver.html)|31e6ae835161f670a6393f36b269a7ad1fa4e667|
|[389-adminutil-1.1.10.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.10.tar.bz2)|adminutil.git|389-adminutil-1.1.10|[AdminUtil](../administration/adminutil.html)|310be539a4cd31a892858cabf609c0d3acedad92|
|[winsync-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.4.tar.bz2)|winsync.git|winsync-1.1.4|[WindowsSync](../howto/howto-windowssync.html|3e45d315038d0694d7f801bd4911e3f1f524191f|
|[389-console-1.1.6.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.6.tar.bz2)|console.git|389-console-1.1.6|[WindowsSync](../howto/howto-windowsconsole.html|06f7128bc86d1429c6fd0a920ecbb0bac9799206|
|[idm-console-framework-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.5.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_5(CVS)|[buildingconsole.html](buildingconsole.html)|15f1d2af4cac986c6caad39f4ed02191169fcb42|
|[389-ds-console-1.2.3.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.3.tar.bz2)|ds-console.git|389-ds-console-1.2.3|[DirectoryConsole](buildingconsole.html#ds-console)|9d433a142a92c7b6a2cc46927dba4140da05810b|
|[389-admin-console-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.5.tar.bz2)|admin-console.git|389-admin-console-1.1.5|[AdminConsole](buildingconsole.html#admin-console)|3baf33f3a045fafb6cd7157e448c9b8453f86721|

### 389 Directory Server 1.2.5

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.5.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.5.tar.bz2)|ds.git|389-ds-base-1.2.5|[Building](building.html)|40340cdf1d1816c5a6b97acfb770c1f5ad6f7f4a|
|[389-admin-1.1.10.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.10.tar.bz2)|admin.git|389-admin-1.1.10|[AdminServer](../administration/adminserver.html)|a1e4f053c6915a500d411306614a6b58c941f93c|
|[389-adminutil-1.1.9.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.9.tar.bz2)|adminutil.git|389-adminutil-1.1.9|[AdminUtil](../administration/adminutil.html)|516cd69f7a0b34f52563a4a5b8e4a6f9b0839177|
|[389-dsgw-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.5.tar.bz2)|dsgw.git|389-dsgw-1.1.5|[DSGW\_Building](../administration/dsgw-building.html)|9ef4a18ddd09a566402f1fd68bef8f774857d680|

### 389 Directory Server 1.2.4

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-ds-base-1.2.4.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.4.tar.bz2)|ds.git|389-ds-base-1.2.4|[Building](building.html)|54a9257a3b979c5c953e69a45739912f919ebdda|
|[winsync-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.3.tar.bz2)|winsync.git|winsync-1.1.3|[WindowsSync](../howto/howto-windowssync.html|d4b7ee3e75e8fec26bd0a3ebf0f4389d14376529|
|[389-console-1.1.4.a1.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.4.a1.tar.bz2)|console.git|389-console-1.1.4.a1|[WindowsSync](../howto/howto-windowsconsole.html|8fc8616889ef8ef9145fb0198ee02dd5b4b0bcd6|

### 389 Directory Server 1.2.3

Modules are git modules and tags are git tags, except where noted as CVS.

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-adminutil-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.8.tar.bz2)|adminutil.git|389-adminutil-1.1.8|[AdminUtil](../administration/adminutil.html)|ff2090c74f63cce65f8222263207ee5442a9e325|
|[389-ds-base-1.2.3.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.3.tar.bz2)|ds.git|389-ds-base-1.2.3|[Building](building.html)|f1ed676a3fa2d118c4b57926502bcba9bcd413ef|
|[389-admin-1.1.9.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.9.tar.bz2)|admin.git,mod\_admserv(CVS),mod\_restartd(CVS)|389-admin-1.1.9,three89Admin\_1\_1\_9(CVS)|[AdminServer](../administration/adminserver.html)|523d0c8b9c88c5c1c1312cc0e89ac15cd07a598c|
|[389-console-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.3.tar.bz2)|console.git|389-console-1.1.3|[389 Console](buildingconsole.html#framework)|b1a5afa6e7039283ac340939d5e1728431370ba9|
|[idm-console-framework-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.3.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_3(CVS)|[buildingconsole.html](buildingconsole.html)|b234a0549e80b739672323e963ae149a5be188df|
|[389-ds-console-1.2.0.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.0.tar.bz2)|ds-console.git|389-ds-console-1.2.0|[DirectoryConsole](buildingconsole.html#ds-console)|403c493f69b94747ea9078799a1f871b71a71d73|
|[389-admin-console-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.4.tar.bz2)|admin-console.git|389-admin-console-1.1.4|[AdmservConsole](buildingconsole.html#admin-console)|29a4ba674b4f532c67ed1303162e5b232bcf9821|
|[389-dsgw-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.4.tar.bz2)|dsgw.git|389-dsgw-1.1.4|[DSGW\_Building](../administration/dsgw-building.html)|52e01146f9b35b46c5deb288806b10624ffff855|
|[winsync-1.1.2.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.2.tar.bz2)|winsync.git|winsync-1.1.2|[WindowsSync](../howto/howto-windowssync.html|7391f4bde7ef8a42bc2722e3f581abe3ac09b639|

### 389 Directory Server 1.2.2

Modules are git modules and tags are git tags, except where noted as CVS.

|Source tarball|git module|git tag|More Info|SHA1SUM|
|--------------|----------|-------|---------|-------|
|[389-adminutil-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/389-adminutil-1.1.8.tar.bz2)|adminutil.git|389-adminutil-1.1.8|[AdminUtil](../administration/adminutil.html)|ff2090c74f63cce65f8222263207ee5442a9e325|
|[389-ds-base-1.2.2.tar.bz2]({{ site.baseurl }}/binaries/389-ds-base-1.2.2.tar.bz2)|ds.git|389-ds-base-1.2.2|[Building](building.html)|459aa7228b7ef775db5ba588a6b795db997da4f4|
|[389-admin-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/389-admin-1.1.8.tar.bz2)|admin.git,mod\_admserv(CVS),mod\_restartd(CVS)|389-admin-1.1.8,three89Admin\_1\_1\_8(CVS)|[AdminServer](../administration/adminserver.html)|4d1eb839581b21053f24f9f0908f20fe60a51c37|
|[389-console-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/389-console-1.1.3.tar.bz2)|console.git|389-console-1.1.3|[389 Console](buildingconsole.html#framework)|b1a5afa6e7039283ac340939d5e1728431370ba9|
|[idm-console-framework-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.3.tar.bz2)|console(CVS)|FedoraConsoleFramework\_1\_1\_3(CVS)|[buildingconsole.html](buildingconsole.html)|b234a0549e80b739672323e963ae149a5be188df|
|[389-ds-console-1.2.0.tar.bz2]({{ site.baseurl }}/binaries/389-ds-console-1.2.0.tar.bz2)|ds-console.git|389-ds-console-1.2.0|[DirectoryConsole](buildingconsole.html#ds-console)|403c493f69b94747ea9078799a1f871b71a71d73|
|[389-admin-console-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/389-admin-console-1.1.4.tar.bz2)|admin-console.git|389-admin-console-1.1.4|[AdmservConsole](buildingconsole.html#admin-console)|29a4ba674b4f532c67ed1303162e5b232bcf9821|
|[389-dsgw-1.1.4.tar.bz2]({{ site.baseurl }}/binaries/389-dsgw-1.1.4.tar.bz2)|dsgw.git|389-dsgw-1.1.4|[DSGW\_Building](../administration/dsgw-building.html)|52e01146f9b35b46c5deb288806b10624ffff855|
|[winsync-1.1.0.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.0.tar.bz2)|winsync.git|winsync\_1\_1\_0|[WindowsSync](../howto/howto-windowssync.html|bb661761138c0f67fe1e33ea870c826e2fdb78b8|

### Fedora Directory Server 1.2.0

|Source tarball|CVS module|CVS static tag|More Info|SHA1SUM|
|--------------|----------|--------------|---------|-------|
|[adminutil-1.1.8.tar.bz2]({{ site.baseurl }}/binaries/adminutil-1.1.8.tar.bz2)|adminutil|adminutil\_1\_1\_8|[AdminUtil](../administration/adminutil.html)|8deb2b018f96270ecb41f3625cdf7069357b25e9|
|[fedora-ds-base-1.2.0.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-base-1.2.0.tar.bz2)|ldapserver|FedoraDirSvr\_1\_2\_0|[Building](building.html)|bbce7a98ebbdc13e4ca11c57cb5990a5d4b1bb87|
|[fedora-ds-admin-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-admin-1.1.7.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin\_1\_1\_7|[AdminServer](../administration/adminserver.html)|2018efb83de6ab3af1ff386197d621f07f67b66f|
|[fedora-idm-console-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/fedora-idm-console-1.1.3.tar.bz2)|fedora-idm-console|FedoraIDMConsole\_1\_1\_3|[Fedora IDM Console](buildingconsole.html#framework)|bc9fd58b7f9266eab3cca025a9030e2c76a67829|
|[idm-console-framework-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.3.tar.bz2)|console|FedoraConsoleFramework\_1\_1\_3|[buildingconsole.html](buildingconsole.html)|b234a0549e80b739672323e963ae149a5be188df|
|[fedora-ds-console-1.2.0.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-console-1.2.0.tar.bz2)|directoryconsole|FedoraDirectoryconsole\_1\_2\_0|[DirectoryConsole](buildingconsole.html#ds-console)|81a6a3647b46d7562bc1dab9e390969aa34ceb8d|
|[fedora-ds-admin-console-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-admin-console-1.1.3.tar.bz2)|admservconsole|FedoraAdmservconsole\_1\_1\_3|[AdmservConsole](buildingconsole.html#admin-console)|6ddebd0771a1ad30721e5c93d926a35e7909618c|
|[fedora-ds-dsgw-1.1.2.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-dsgw-1.1.2.tar.bz2)|dsgw|FedoraDirSvrDSGW\_1\_1\_2|[DSGW\_Building](../administration/dsgw-building.html)|f0e86c79da993fa8d01c7f3d90eef9c39d69c8d8|
|[winsync-1.1.0.tar.bz2]({{ site.baseurl }}/binaries/winsync-1.1.0.tar.bz2)|winsync|winsync\_1\_1\_0|[WindowsSync](../howto/howto-windowssync.html|bb661761138c0f67fe1e33ea870c826e2fdb78b8|

### Fedora Directory Server 1.1.3

This includes only the fedora-ds-base package. All of the other packages are the same as for 1.1.2

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[fedora-ds-base-1.1.3.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-base-1.1.3.tar.bz2)|ldapserver|FedoraDirSvr\_1\_1\_3|[Building](building.html)|65aeecb66a6977f7f4706569d02ad8ce|

### Fedora Directory Server 1.1.2

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[adminutil-1.1.7.tar.bz2]({{ site.baseurl }}/binaries/adminutil-1.1.7.tar.bz2)|adminutil|adminutil\_1\_1\_7|[AdminUtil](../administration/adminutil.html)|e7d03be4651b36d1213b4f5cc15dfc5c|
|[fedora-ds-base-1.1.2.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-base-1.1.2.tar.bz2)|ldapserver|FedoraDirSvr\_1\_1\_2|[Building](building.html)|797c93351e8fcca9bac6326e7270355e|
|[fedora-ds-admin-1.1.6.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-admin-1.1.6.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin\_1\_1\_6|[AdminServer](../administration/adminserver.html)|63a2b5f4496d0cb4b067160fc9da5fd8|
|[idm-console-framework-1.1.2.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.2.tar.bz2)|console|FedoraConsoleFramework\_1\_1\_2|[buildingconsole.html](buildingconsole.html)|f2db919004fcaf5d6adf6db55b4d589f|
|[fedora-ds-console-1.1.2.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-console-1.1.2.tar.bz2)|directoryconsole|FedoraDirectoryconsole\_1\_1\_2|[DirectoryConsole](buildingconsole.html#ds-console)|62964d896042c032143d9bac60abd105|
|[fedora-ds-admin-console-1.1.2.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-admin-console-1.1.2.tar.bz2)|admservconsole|FedoraAdmservconsole\_1\_1\_2|[AdmservConsole](buildingconsole.html#admin-console)|e40ffc75263637e886fdf62b20e9a628|
|[fedora-ds-dsgw-1.1.1.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-dsgw-1.1.1.tar.bz2)|dsgw|FedoraDirSvrDSGW\_1\_1\_1|[DSGW\_Building](../administration/dsgw-building.html)|fd86e38de705e75296100d7fe9025970|

### Fedora Directory Server 1.1.1

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[fedora-ds-base-1.1.1.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-base-1.1.1.tar.bz2)|ldapserver|FedoraDirSvr111|[Building](building.html)|c525e0412ae4b9582adbd01305126975|
|[idm-console-framework-1.1.1.tar.bz2]({{ site.baseurl }}/binaries/idm-console-framework-1.1.1.tar.bz2)|console|FedoraConsoleFramework112|[buildingconsole.html](buildingconsole.html)|a23291c9aea256f075b69df981fae42a|
|[fedora-idm-console-1.1.1.tar.bz2]({{ site.baseurl }}/binaries/fedora-idm-console-1.1.1.tar.bz2)|fedora-idm-console|FedoraIDMConsole112|[IDMConsole](buildingconsole.html#framework)|4c2b16080a3c6e477924091c02d721bf|
|[fedora-ds-console-1.1.1.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-console-1.1.1.tar.bz2)|directoryconsole|FedoraDirectoryconsole112|[DirectoryConsole](buildingconsole.html#ds-console)|ee0401937a81ce2466292a4f9b14e20a|
|[fedora-admin-console-1.1.1.tar.bz2]({{ site.baseurl }}/binaries/fedora-admin-console-1.1.1.tar.bz2)|admservconsole|FedoraAdmservconsole112|[AdmservConsole](buildingconsole.html#admin-console)|e0f16a5a426a2c2bceefb5cfb99ea9c7|
|[fedora-ds-admin-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-admin-1.1.5.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin115|[AdminServer](../administration/adminserver.html)|766c2ab5a7659450ac9fb37fac5ddeb5|
|[adminutil-1.1.6.tar.bz2]({{ site.baseurl }}/binaries/adminutil-1.1.6.tar.bz2)|adminutil|FedoraAdminutil116|[AdminUtil](../administration/adminutil.html)|b01d441f81d3d260ba84e4f0d5311721|
|[mod\_nss-1.0.7.tar.gz]({{ site.baseurl }}/binaries/mod_nss-1.0.7.tar.gz)|mod\_nss|mod\_nss107|[mod\_nss](../administration/mod-nss.html)|71107cbc702bf07c6c79843aa92a0e09|

### Fedora Directory Server 1.1.0

These are the sources which were used to build the initial 1.1.0 release.

|Source tarball|CVS module|CVS static tag|More Info|MD5SUM|
|--------------|----------|--------------|---------|------|
|[idm-common-framework-1.1.0.tar.bz2]({{ site.baseurl }}/binaries/idm-common-framework-1.1.0.tar.bz2)|console|FedoraConsoleFramework111|[buildingconsole.html](buildingconsole.html)|a24d54361b12984b07fc01ff8f8af447|
|[fedora-idm-console-1.1.0.tar.bz2]({{ site.baseurl }}/binaries/fedora-idm-console-1.1.0.tar.bz2)|fedora-idm-console|FedoraIDMConsole111|[IDMConsole](buildingconsole.html#framework)|e76a8212c6eaaaab3333aa076ca5499d|
|[fedora-ds-console-1.1.0.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-console-1.1.0.tar.bz2)|directoryconsole|FedoraDirectoryconsole111|[DirectoryConsole](buildingconsole.html#ds-console)|7b69248b8f18484f03e260a144b1265c|
|[fedora-admin-console-1.1.0.tar.bz2]({{ site.baseurl }}/binaries/fedora-admin-console-1.1.0.tar.bz2)|admservconsole|FedoraAdmservconsole111|[AdmservConsole](buildingconsole.html#admin-console)|32ecb58f33660705edcd8c3606de750d|
|[fedora-ds-base-1.1.0.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-base-1.1.0.tar.bz2)|ldapserver|FedoraDirSvr110|[Building](building.html)|a60d1ce51207e61c48b70aa85ae5e5a5|
|[fedora-ds-admin-1.1.1.tar.bz2]({{ site.baseurl }}/binaries/fedora-ds-admin-1.1.1.tar.bz2)|adminserver,mod\_admserv,mod\_restartd|FedoraDirSrvAdmin112|[AdminServer](../administration/adminserver.html)|f50f2b6c983851c5e912047807bbcca6|
|[adminutil-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/adminutil-1.1.5.tar.bz2)|adminutil|FedoraAdminutil115|[AdminUtil](../administration/adminutil.html)|1ce95159db07040d7095b805e9b3b533|
|[mod\_nss-1.0.7.tar.gz]({{ site.baseurl }}/binaries/mod_nss-1.0.7.tar.gz)|mod\_nss|mod\_nss107|[mod\_nss](../administration/mod-nss.html)|71107cbc702bf07c6c79843aa92a0e09|

### 389 Directory Password Synchronization 1.1.5

This is the source which were used to build the 389 Directory Password Synchronization.

|Source tarball|git module|git tag|MD5SUM|
|--------------|----------|-------|------|
|[389-passsync-1.1.5.tar.bz2]({{ site.baseurl }}/binaries/389-passsync-1.1.5.tar.bz2)|winsync|winsync-1.1.5|6ab371314606a9b0f4d7831e9a66c759|


