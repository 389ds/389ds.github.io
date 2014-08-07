---
title: "DSML"
---

# Directory Server DSML Gateway
-------------------------------

{% include toc.md %}

### Overview

-   Fedora Directory Server can work with a Java gateway application based on Directory Service Markup Language (DSML) version 2.0.
-   Directory Service Markup Language (DSML) is an open, extensible format that allows directories to exchange information across Directory Server types. The flexibility of DSML enables clients to interact with customers, partners, and remote locations, regardless of the type of directory service used.
-   DSML version 2.0, the basis for Directory Server's DSML gateway, allows directory contents to be accessed, modified, and controlled through XML (eXtensible Markup Language). Delivering directory information in XML allows customized markup languages to be created for different uses by extending the XML schema.
-   As a web services protocol, DSML closely mirrors Lightweight Directory Access Protocol (LDAP). DSML is designed to allow arbitrary web services clients to access directory services using the client's native protocols, so that content stored in a directory service can be easily accessed by standard web service applications and development tools. DSML is useful in web applications because it can access directories when a firewall would normally screen out an LDAP request.
-   The Directory Server DSML gateway uses SOAP as a services layer. Simple Object Access Protocol (SOAP) is an XML-based protocol that can access and relay information in a distributed database over regular HTTP/HTTPS. The DSML gateway uses SOAP to bind to a Directory Server over the web so LDAP directories, such as Directory Server, can be effectively rendered in XML.

### Links

-   [Design](dsml-gateway-design.html)
-   [Building](#build-gateway)
-   [License - GPLv2 with GNU Classpathx exception](dsml-gateway-license.html "wikilink")

### DSML Authentication Mapping

The DSML authentication mechanism is native to HTTP/SOAP, but the gateway interacts cleanly with LDAP. Client credentials sent through either standard HTTP client authentication or SSL connections are mapped to a distinguished name (DN), and then proceed as if an LDAP client had bound with that DN.
The gateway DN mapping works essentially as follows:

1.  The client's authentication credentials are obtained from the servlet container (username/password from HTTP/SOAP or client certification DN from SSL).
2.  A mapping function is applied to yield a target DN in the host Directory Server's directory information tree.
3.  The gateway attempts to verify the presented credentials by binding as the mapped DN against the host Directory Server.
4.  If the gateway binds successfully, the session is marked as authenticated.
5.  For authenticated sessions, LDAP proxy authorization controls are sent with every operation to the Directory Server. This ensures that operations are done in the security context of the presented credentials (as mapped).

Response times for a gateway are slightly higher compared to a native Directory Server session because each request must be forwarded through the gateway. Overall, though, implementation as a gateway, as opposed to natively within the Directory Server, offers two major benefits for how the gateway can be integrated into your broader network:

-   Improved throughput since XML-parsing, which is CPU-intensive, can be done on a different CPU than the server uses.
-   Simpler integration with emerging web services protocols can be added without affecting Directory Server performance.

The DSML gateway is implemented as a Java application, which offers several benefits:

-   Execution in a wide range of operating system and hardware environments, including those that do not support Directory Server.
-   Leverage of existing Java web services implementations.
-   Deployment within almost any execution environment. Installation is easy even without experience using Java web services.

### Using DSML Gateway with Directory Server

To use the DSML gateway application as part of the Directory Server deployment:

1.  Make sure the machine or application that uses the gateway must be SOAP compatible since the DSML gateway natively runs over HTTP/SOAP.
2.  Install Directory Server, then [build and install](#build-gateway) the DSML gateway on the same machine.
3.  Directory Server has other web applications ” the Directory Server Gateway, Admin Express, Directory Express, and Org Chart” along with the DSML gateway. The DSML gateway can run simultaneously with the other web applications; however, it does not interact with them.
4.  Activate the the DSML gateway. The DSML gateway is not running by default and has to be enabled, as covered in [Activating the Gateway](#enable-dsml).
5.  Modify the configuration files, if necessary.

During installation and setup, the files relevant to the DSML gateway are placed in `/usr/share/dirsrv/dsmlgw`. The configuration information is stored in `/etc/dirsrv/dsmlgw/dsmlgw.cfg`. You can modify desired settings in the file and customize the application to suit an organization.
The gateway connects to the default port (`389`) of Directory Server. See ["Editing the DSML Gateway Configuration"](#edit-dsml "wikilink") for detailed information on configuration parameters. The default settings (created during setup) are usually sufficient.

### <a name="build-gateway"></a>Building the DSML Gateway
-------------------------

The DSML gateway is built from source; pre-built packages are not yet available.

### Build Requirements

In order to build the DSML gateway, you need the following:

-   Java 1.5 or later
-   Ant 1.6 or later
-   Axis 1.4 (The DSML gateway code will not currently work with Axis2). `axis.jar`, `saaj.jar`, and `jaxrpc.jar` are usually provided with your OS distro, or with binary distributions of Axis, but they can be built from the Axis 1.4 source code if necessary.
-   Mozilla LDAP Java SDK 4.17 or later. `ldapjdk.jar` is usually provided with your OS distro, but it is also available from jpackage.org.
-   Java Activation Framework 1.0 or later. `activation.jar` is usually provided with your OS distro, but the Sun or the GNU Classpathx versions are also acceptable.
-   Apache Commons Codec. `commons-codec.jar` is usually provided with your OS distro, but it can also be downloaded from apache.org.

### Getting the Source Code

    git clone git://git.fedorahosted.org/cgit/389/dsmlgw.git/


### Build Properties

Some of the default values are in the build.properties file. There are also `build.properties` files for each of the `pkg.type` used by the `makepkg` build target.

Other build properties are specified on the `ant` command. For example:

    ant -Dbuild.dir=*/path/to/build* -Ddist.dir=*/path/to/dist .... [targets]*

The build takes many different options depending on how you want to build and what is provided by your platform:

|**Option**|**Default**|**Description** |
|----------|-----------|----------------|
|globaldist.dir|/usr/share/java|Common shared jar directory - some distros put all jars in this directory|
|ldapdist.dir|/usr/share/java|Directory containing ldapjdk.jar|
|axisdist.dir|/usr/share/java/axis|Home directory for all Axis files|
|axis.lib.dir|/usr/share/java/axis|Directory containing axis.jar, saaj.jar, jaxrpc.jar|
|axis.jar|\${axis.lib.dir}/axis.jar|Explicitly specify path and filename of axis jar to use |
|saaj.jar|\${axis.lib.dir}/saaj.jar|Explicitly specify path and filename of saaj jar to use |
|jaxrpc.jar|\${axis.lib.dir}/jaxrpc.jar|Explicitly specify path and filename of jaxrpc jar to use |
|ldapjdk.jar|\${ldapdist.dir}/ldapjdk.jar|Explicitly specify path and filename of ldapjdk jar to use |
|activation.jar|\${globaldist.dir}/activation.jar|Explicitly specify path and filename of JAF jar to use |
|codec.jar|\${globaldist.dir}/commons-codec.jar|Explicitly specify path and filename of codec jar to use |
|mail.jar|\${globaldist.dir}/mail.jar|Not needed at build time, but required by Axis and DSMLGW service at runtime |
|build.dir|built|Where to write .class files and other files generated during build |
|dist.dir|dist|Where to write jar and war files and directories |
|pkg.dir|\${dist.dir}/pkg|Where to write the .tar.gz files and packaging directories |
|pkg.type|prefix|Type of package to create - prefix, fhs, or fhsopt |
|tomcat.home|no default value|The CATALINA\_HOME or tomcat home directory to use at runtime - must be specified if packaging |
|tomcat.cmd|\${tomcat.home}/bin/startup.sh|Command to use at runtime to startup Tomcat - must be specified if packaging |

### Build Targets

These are the targets you can provide to `ant`, depending on the desired build type:

-   *dist* (default). This just builds the `dsmlgw.jar` file.
-   *makewar*. This builds the `dsmlgw.jar` file, bundles Axis and the other jar files, and creates an Axis web application with DSML gateway that can be deployed into Tomcat or other compliant servlet container.
-   *makepkg*. This creates a full redistributable package, including the shell scripts and config files, in a `.tar.gz` file. The layout is based on the `pkg.type` specified:
    -   *prefix* puts all files and directories under a given prefix; the default directory is `/opt/dirsrv`.
    -   *fhs* puts all files and directories under their FHS locations; the main directory is under `/usr/share/dirsrv/dsmlgw`.
    -   *fhsopt* uses the FHS `/opt` layout (`/opt/dirsrv`, `/etc/opt/dirsrv`, and `/var/opt/dirsrv`) .

DSML Gateway Tools
------------------

The DSML gateway is controlled through a single command-line utility, `/usr/sbin/setup-ds-dsmlgw`. The `setup-ds-dsmlgw` tool has one option, listed in "Table: Gateway Command-Line Options,".

|**Option**|**Description**|
|-r|*Optional*. Rewrites the configuration. By default, setup-ds-dsmlgw will not overwrite any existing config.|

Scripts
-------

These scripts are provided with the full package distribution (i.e. not jar or war only):

-   sbin/setup-ds-dsmlgw - sets up the Tomcat app environment and the DSMLGW configuration
-   sbin/start-ds-dsmlgw - start up tomcat + axis + dsmlgw service
-   sbin/stop-ds-dsmlgw - shutdown
-   sbin/restart-ds-dsmlgw - restart
-   bin/dsmlgw-search - a very simple script to use to test DSMLv2 searches via the DSMLGW
-   bin/dsml2ldif - converts DSMLv1 data files to LDIF format
-   bin/ldif2dsml - converts LDIF files to DSMLv1 data files

### <a name="edit-dsml"></a>Editing the DSML Gateway Configuration
--------------------------------------

The gateway is configured by running setup-ds-dsmlgw.
The configuration settings are stored in a Java properties text file, `/etc/dirsrv/dsmlgw/dsmlgw.cfg`.
"Table: Configuration Parameters" lists the DSML gateway configuration file parameters.

|**Parameter**|**Description**|**Default Setting**|
|-------------|---------------|-------------------|
|ServerHost|Host name for its peer Directory Server.|localhost|
|ServerPort|Port number for its peer Directory Server.|389|
|BindDN|Bind DN.|anonymous|
|BindPW|Bind password.|(empty)|
|MinimumConnectionPool|Minimum connections the DSML gateway will make to the Directory Server for operations.|3|
|MaximumConnectionPool|Maximum connections the DSML gateway will make to the Directory Server for operations.|15|
|MinimumLoginPool|Minimum connections the DSML gateway will make to the Directory Server for user authentication.|1|
|MaximumLoginPool|Maximum connections the DSML gateway will make to the Directory Server for user authentication.|2|
|UseAuth|`true|false` expression. If the expression is `true`, it requires the user to authenticate in order to bind; if it is `false`, it accepts the user ID and password offered.|false|

#### Changing the Host

1.  Open the `dsmlgw.cfg` file in the `/etc/dirsrv/dsmlgw` directory.
2.  Edit the value of the `ServerHost` attribute to reflect the server you wish to use. For example:
    `ServerHost=ldap.example.com`
3.  Restart the gateway `/usr/sbin/restart-ds-dsmlgw`

#### Changing the Bind DN and Password

The default setting allows read-only access since the default bind DN is `anonymous`. Changing the bind DN to a DN that has read-write permissions will allow read-write access for the directory.

If the `UseAuth` attribute value is set to `true`, the gateway requires standard HTTP headers, consisting of the user's full distinguished name and password. Any operations done over the gateway will be done with proxy authorization and will require a distinguished name with proxy rights. For more about proxy authorization, see the <em class="citetitle">Directory Server Administrator's Guide</em>.

1.  Open the `dsmlgw.cfg` file in the `/etc/dirsrv/dsmlgw` directory.
2.  Edit the value of the BindDN attribute to reflect the user for whom you are allowing access. For example:
    `BindDN=uid=fred,ou=people,dc=example,dc=com`
3.  Edit the value of the `BindPW` attribute; for anonymous access, this parameter is usually blank. The new password must be the same as the password for authentication to the directory to keep access controls functioning. For example:
    `BindPW=password`
4.  Restart the gateway `/usr/sbin/restart-ds-dsmlgw`

### Example Configuration

The following is an example gateway configuration for `example.com` Corporation. Parameters not listed in the file are set to the default value.

    # DSMLGW configuration for example.com Corporation
    ServerHost=ldap.example.com
    ServerPort=389
    BindDN=uid=fred,ou=people,dc=example,dc=com
    BindPW=password
    UseAuth=false`

### DSML Samples

Sample DSML data files are provided with the full package distribution in the `share/dirsrv/dsmlgw/data` directory.

### Debugging

In the full package distribution, the log files are written to the directory `share/dirsrv/dsmlgw/webapps/logs` which will be symlinked to your "real" log file directory.

For Axis debugging, edit the file `share/dirsrv/dsmlgw/webapps/axis/WEB-INF/log4j.properties`. This uses standard Log4j properties. The file axis.log (in the log directory above) will contain Axis specific log messages.

For DSMLGW debugging, edit the file `share/dirsrv/dsmlgw/webapps/axis/WEB-INF/logging.properties`. The log file name is `dsmlgw.<date>.log` (in the log directory above).

See Also
========

-   Back to the [overview](webapps_overview.html)
-   How to [install and setup](webapps_install.html) the web apps
-   [Org Chart](orgchart.html)
-   [Directory Server Gateway](dsgw.html)
-   [Admin Express](adminexpress.html)
-   [Directory Express](dsexpress.html)
-   Help with [basic HTML editing](htmlediting.html)

