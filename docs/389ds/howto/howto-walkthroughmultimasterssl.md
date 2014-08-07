---
title: "Howto: WalkthroughMultimasterSSL"
---

# Walk Through of MMR SSL Setup
----------------------------------

In this example we are creating a 4 node Linux LDAP environment and implementing multi-master replication. The 4 nodes are all masters in this example but I will document the process of 2 masters and 2 slaves as well. SSL is also detailed in this example both for connections to the host as well as SSL replication. Importing OpenLDAP schema is also discussed.

{% include toc.md %}

### Prerequisites

1) Compatible Linux variant

2) RH httpd installation

3) Sun or IBM Java JRE installation

4) RPM from <http://directory.fedoraproject.org/wiki/Download>

5) Ensure forwarding of X11 so the console will work (optional)

6) Assumes /opt/fedora-ds is your program root for examples in this guide

### Install the Fedora DS RPM


    # rpm -ivh fedora-ds-1.0.4-1.RHEL4.i386.opt.rpm
    # /opt/fedora-ds/setup/setup


1) Choose Option 2 for typical installation.

2) You will keep the defaults for most every option in this script.

3) Choose a sane port **and remember it** for the administration console that can be consistent across all nodes, this makes for easier administration later on.

4) Remember the password you set for cn=Directory Manager... this will be used for MMR.

5) Repeat this same process for the other 3 nodes

### Add the Replication Manager DN Account

This uses ldapmodify. There are other ways to do this but I've found this to be the quickest way. This **must** be done on all 4 nodes.


    # cd /opt/fedora-ds/shared/bin
    # ./ldapmodify -D "cn=Directory Manager" -w YOURPASSWORD
    dn: cn=replication manager,cn=config
    changetype: add
    objectclass: top
    objectclass: person
    cn: Replication Manager
    sn: Manager
    userPassword: PASSWORD


This command continues to wait for input until you issue a **Control-D** to signal the end of input. You should get a message about the user being successfully added. If you do not, go back and check your syntax. **Control-C** to return to a prompt.

### Generate SSL certs

Skip this section if you're not using SSL.

There are lots of guides out there for generating SSL certs. I will not detail the entire process here but rather the important and relevant information for use with Fedora DS. FDS uses the pkcs12 format.

Once you have your .crt and .key files for your server and for your CA you can continue below with the following commands. I suggest creating a directory in /tmp to store your cert files during the installation process.


    # /tmp/certs > openssl pkcs12 -export -in yourserver.crt -inkey yourserver.key -out yourserver.pkcs12 -name "FDS_server"
    (Enter passwords, etc)


Now that your certs are in the proper format we need to install them into FDS's database Note that 'alias' is a directory within your install root.


    # /opt/fedora-ds > /opt/fedora-ds/shared/bin/pk12util -i /tmp/certs/yourserver.pkcs12 -d alias -P slapd-yourhost-


### Start the Admin Console

    # cd /opt/fedora-ds
    $ ./startconsole -u admin -a http://yourhost.yourdomain:yourport

### Set Up Multi-Master Replication

First, some nomenclature. In this document I will refer to each node as a letter. In this example we are creating master/supplier servers capable of read/write. Nodes A,B,C,D.

#### Configure Master Nodes A, B, C, D

On the left side in the tree structure, expand all the possible boxes until you see the Directory Server icon, click on it. On the right hand side you will see a button that says 'Open' near the top. This will open the Directory Server GUI.

1) Click the Configuration Tab

2) Click on the Replication Folder on the left, this will bring up a page on the right. Click 'Enable Changelog' and then click the 'Use Default' button to populate the box. Be sure to click 'Save'

3) Back on the left, expand the Replication Folder until you see your databases. Click on the database you wish to replicate. On the right you will see a menu in which you need to use the following options.

a) Click 'Enable Replica'

b) Choose the 'Multi-Master' radio button

c) Under Common Settings choose a unique replica ID. Start with 1 and increment, make sure not to reuse a number twice.

d) Where it asks for a Supplier DN, use the special Replication Manager DN we set up earlier (cn=replication manager, cn=config) and add it

e) Under current referrals use the other read/write nodes. (IE if you're setting up Node A, use Node B, C, D's hostname) Use the construct button to easily build this line. Make sure you click the 'Add' button afterwords.

f) Save your settings

#### Configure Master Nodes A, B, C, D with 2 suppliers / 2 consumers (optional)

Use this only if you're not doing 4 master servers

The process is the same except that instead of choosing the 'Multi-Master' radio button you are going to choose 'Dedicated Consumer' instead. Also keep in mind that you will **only need to set up replication agreements on your 2 supplier servers.**

### Configure Multi-Master Replication Agreements

Now that MMR has been set up on all nodes, we need to create replication agreements on **all** supplier servers.

#### Configure Nodes A, B, C, D with SSL

Back at the Replication Folder...

1) Right-click on the database you just configured in the previous step. Choose 'New Replication Agreement'

2) Name it something logical like.. 'Node B' or the hostname of Node B, etc.

3) Under Consumer, choose the 'Other' button. Type in the name of the other supplier hosts. (IE if you're doing Node A, choose Node B here) Make sure you use port 636 for your consumer server here. **Note:** the supplier server will ALWAYS show 389, this is a misnomer in this case so don't be concerned that it shows 389 -\> 636 here. As long as you choose the right port on the consumer and follow the next step it will work.

4) Click the check box about using SSL connections

5) Under the Bind section, enter your special Replication Manager DN yet again. (cn=replication manager, cn=config)

6) Click 'Next' twice until prompted for initialization settings

7) I recommend against choosing initialize in this menu. It is possible but I've had mixed results here. It is much easier to choose 'Do Not Initialize Now' and do them all at the same time later on in the install.

8) Repeat this process and make agreements for Nodes B, C and D as well.

8) Do the same via the DS Gui on Nodes B, C, D but this time choose the other hosts.

**When you are finished with this process you should have 3 agreements on each supplier. On Node A you should have an agreement with Node B, C and D. On Node B you should have agreements with Node A, C and D and so on.**

#### Configure Nodes A, B, C, D without SSL

If you do not plan to use SSL, follow the same steps above except choose port 389 for your consumer port and do not click the SSL box.

#### Initialize

On Node A, simply right click on each of your replication agreements and choose Initialize.. this way you can be sure you're only doing it once and therefore you don't have to worry about doing this step on any other node.

At this point your 4 node LDAP environment should be set up properly. You can observe that your replication worked properly by clicking on each replication agreement and looking on the right page under status. You should see a date/time stamp and a message indicating that it succeeded. If you see an error here you have mis-configured something and should retrace your steps. Before redoing anything, make sure you try a 'Refresh' from the menu, sometimes it does not redraw properly.

### Setting up SSL certs

Skip this step if you don't plan on using SSL. Make sure you've followed the earlier steps for installing the SSL certs before continuing. From the DS console, choose the Configuration tab, then choose Encryption from the tabs on the right.

1) Click Enable SSL for this server

2) Choose 'Use this cipher...' You should see the cert you created under the certificate drop down menu

3) Choose 'Allow client auth..' but use whatever fits your needs.

4) Click the check box about hostname checking

5) Click Save

From the DS console, choose 'Manage Certificates' from the Tasks menu

You should see your certificate listed in the menu here. If you do not, go back and follow the previous instructions as it should be here before continuing.

6) Choose the CA certs tab

7) Click the Install button at the bottom

8) Navigate to your cert directory (/tmp/certs in this example) and choose your CA.crt

9) Click 'Next' twice until you have two check boxes, make sure they're both checked and click 'Apply'

You should now see your CA listed at the top, go back to the Server Certs page and click details on the cert you made. Make sure the Certificate Path tab has a logical flow presented. If there is a message about it being broken you need to fix your CA cert.

### Importing Schema

All schema in FDS are stored in LDIF format here:

	$> pwd
	$> /opt/fedora-ds/slapd-yourhost/config/schema/

To use existing OpenLDAP configs you will need to get this converter:

<http://directory.fedoraproject.org/download/ol-schema-migrate.pl>

A word on nomenclature... your LDIF files should load in order or else you will have reference integrity issues. All your LDIF files should begin with a number; the lowest number loading first. For example, if I needed something from File A to load File B properly, I would name them 90FileA and 91FileB

Using the script converts the file and formats it properly for the FDS system. 

    $> ./script.pl -b openldap.schema > yourfile.ldif


Place this file in the above directory and restart the server.. if it hangs then check here: 

    $> pwd
    $> /opt/fedora-ds/slapd-yourhost/logs/errors


Otherwise you should be good to go. I hope this was helpful!

