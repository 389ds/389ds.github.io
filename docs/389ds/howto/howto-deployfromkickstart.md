---
title: "Howto:DeployFromKickstart"
---

# Deploy From Kickstart
-----------------------

{% include toc.md %}

Overview
--------

This is an automated build procedure for Deploying Fedora-DS on CentOS/RHEL 5.2 You just ensure that you have built the RPMs you need and merged them into your kickstart repository with createrepo. [Build RPM's for Centos/RHEL](howto-buildrpmsforcentos-rhel.html) If the rpms aren't in your repo, you don't have much hope of pulling this off...

The Kickstart Files
-------------------

The primary LDAP server will be the one whose configuration server we register all of our other servers with. (The stuff in bold type needs to be changed to suit your network.

### primary kickstart file

	install
	lang en_US.UTF-8
	langsupport --default en_US.UTF-8 en_US.UTF-8
	keyboard us
	mouse genericwheelps/2 --device psaux
	skipx
	network --device eth0 --bootproto static --ip 192.168.0.110 --netmask 255.255.255.0 --gateway 192.168.0.1 --nameserver 192.168.0.1 --hostname faraday.example.com
	url --url http://192.168.0.1/centos/5.2/base
	# passwd == icanhasarealpasswdplzkthxbai!
	rootpw --iscrypted  $1$hRkd4xmC$I0RUo2VB.2IWcSWAoFimW/
	firewall --enabled
	authconfig --enableshadow --enablemd5
	timezone America/Chicago
	zerombr yes
	bootloader --location=mbr
	clearpart --all
	part /boot --fstype ext3 --size=256
	part swap  --fstype swap --size=1024
	part pv.3                --size=8192
	part pv.4                --size=128 --grow
	volgroup vg0 pv.3
	volgroup vg_opt pv.4
	logvol /     --fstype ext3 --name=root --vgname=vg0    --size=768
	logvol /home --fstype ext3 --name=home --vgname=vg0    --size=256
	logvol /usr  --fstype ext3 --name=usr  --vgname=vg0    --size=3072
	logvol /var  --fstype ext3 --name=var  --vgname=vg0    --size=2048
	logvol /tmp  --fstype ext3 --name=tmp  --vgname=vg0    --size=1024
	logvol /opt  --fstype ext3 --name=opt  --vgname=vg_opt --size=128 --grow
	reboot
	%packages
	@Base
	dhcp
	sendmail-cf
	cfengine
	xorg-x11-xauth
	xterm
	java-1.5.0-sun
	java-1.5.0-sun-devel
	java-1.5.0-sun-fonts
	fedora-ds
	openldap-clients
	-java-1.5.0-ibm
	-java-1.5.0-ibm-devel
	-gpm
	%post
	# First boot fixups
	echo "echo 60 > /proc/sys/net/ipv4/tcp_keepalive_time" >> /etc/rc.local
	/bin/cp /etc/rc.local /etc/rc.local.dist
	/bin/cat<<EOFB>/usr/local/sbin/firstrun
	#!/bin/bash
	echo "Making final configuration changes"
	EOFB
	chmod 744 /usr/local/sbin/firstrun
	/bin/cat<<EORCL>/etc/rc.local
	#!/bin/bash
	/usr/local/sbin/firstrun
	EORCL
	chmod 755 /etc/rc.local
	/bin/rm /etc/yum.repos.d/*.repo
	/bin/cat<<EOREPO>/etc/yum.repos.d/myown.repo
	[centos52]
	name=My CentOS 5.2 Repository
	baseurl=http://192.168.0.1/centos/5.2/base/CentOS
	enabled=1
	gpgcheck=0
	EOREPO
	/bin/chmod 644 /etc/yum.repos.d/myown.repo
	/bin/cat<<EOSEL>/etc/selinux/config
	SELINUX=disabled
	SELINUXTYPE=targeted
	EOSEL
	/bin/chmod 644 /etc/selinux/config
	/bin/cat<<EOIPT>/etc/sysconfig/iptables
	# Firewall configuration written by system-config-securitylevel
	# Manual customization of this file is not recommended.
	*filter
	:INPUT ACCEPT [0:0]
	:FORWARD ACCEPT [0:0]
	:OUTPUT ACCEPT [0:0]
	:RH-Firewall-1-INPUT - [0:0]
	-A INPUT -j RH-Firewall-1-INPUT
	-A FORWARD -j RH-Firewall-1-INPUT
	-A RH-Firewall-1-INPUT -i lo -j ACCEPT
	-A RH-Firewall-1-INPUT -p icmp --icmp-type any -j ACCEPT
	-A RH-Firewall-1-INPUT -p 50 -j ACCEPT
	-A RH-Firewall-1-INPUT -p 51 -j ACCEPT
	-A RH-Firewall-1-INPUT -p udp --dport 5353 -d 224.0.0.251 -j ACCEPT
	-A RH-Firewall-1-INPUT -p udp -m udp --dport 631 -j ACCEPT
	-A RH-Firewall-1-INPUT -p tcp -m tcp --dport 631 -j ACCEPT
	-A RH-Firewall-1-INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 389 -j ACCEPT
	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 636 -j ACCEPT
	-A RH-Firewall-1-INPUT -m state --state NEW -m tcp -p tcp --dport 9380 -j ACCEPT
	-A RH-Firewall-1-INPUT -j REJECT --reject-with icmp-host-prohibited
	COMMIT
	EOIPT
	cat<<EOCP>/usr/local/bin/setclasspath
	#! /bin/bash
	export JAVA_HOME='/usr/lib/jvm/java-1.5.0-sun'
	set_cp() {
	 local jvm_jars=\$(find \$JAVA_HOME/ -iname "*.jar" -printf '%p:')
	 local shr_jars=\$(echo /usr/share/java/*.jar | sed 's/ /:/g')':'
	 local loc_jars=\$(echo /usr/local/share/java/*.jar | sed 's/ /:/g')':'
	 export CLASSPATH=\$(echo .:\$jvm_jars\$shr_jars\$loc_jars)
	}
	ecp() {
	 echo \$CLASSPATH | sed 's/:/\n/g'
	}
	# set class path by default
	set_cp
	EOCP
	chmod 755 /usr/local/bin/setclasspath
	/usr/local/bin/setclasspath
	# Remove the beeping
	cat<<EOF>/root/.inputrc
	set prefer-visible-bell
	EOF
	cat<<EOF>/etc/skel/.inputrc
	set prefer-visible-bell
	EOF
	# Fedora-ds-admin setup
	/bin/cat<<EOF>/root/setup.inf
	[General]
	FullMachineName= faraday.example.com
	SuiteSpotUserID= nobody
	SuiteSpotGroup= nobody
	AdminDomain= rds.example.com
	ConfigDirectoryAdminID= admin
	ConfigDirectoryAdminPwd= admin123
	ConfigDirectoryLdapURL= ldap://faraday.example.com:389/o=NetscapeRoot
	[slapd]
	SlapdConfigForMC= Yes
	UseExistingMC= No
	ServerPort= 389
	ServerIdentifier= faraday
	Suffix= dc=example,dc=net
	RootDN= cn=Directory Manager
	RootDNPwd= password123
	[admin]
	Port= 9380
	ServerIpAddress= 192.168.0.110
	ServerAdminID= admin
	ServerAdminPwd= admin123
	SysUser= nobody
	EOF
	/bin/cat<<EOFDS>>/usr/local/sbin/firstrun
	/usr/sbin/setup-ds-admin.pl -s -f /root/setup.inf
	EOFDS
	# put the old rc.local back and fire off a reboot. (this needs to go last)
	/bin/cat<EOFIXUPS>> /usr/local/sbin/firstrun
	/bin/mv /etc/rc.local.dist /etc/rc.local
	if [ ! -f /etc/.firstrun_ran ];then
	    touch /etc/.firstrun_ran
	    reboot
	fi
	EOFIXUPS

**Note you're going to want to change anything in bold type**

### secondary kickstart files

Secondary kickstart files will be the same as the Primary one *(after changing out the hostname and IP information specific to the host)*

and the section between:

    # Fedora-ds-admin setup
    /bin/cat<<EOF>/root/setup.inf

and

    EOF

Should be replaced with:

    [General]
    AdminDomain = rds.example.com
    SuiteSpotGroup = nobody
    ConfigDirectoryLdapURL =     ldap://faraday.example.com:389/o=NetscapeRoot
    ConfigDirectoryAdminID = admin
    FullMachineName = maxwell.example.com
    SuiteSpotUserID = nobody
    ConfigDirectoryAdminPwd = admin123
    [admin]
    ServerAdminID = admin
    ServerAdminPwd = admin123
    SysUser = nobody
    Port = 9380
    [slapd]
    InstallLdifFile = suggest
    ServerIdentifier = maxwell
    ServerPort = 389
    AddOrgEntries = Yes
    RootDN = cn=Directory         Manager
    RootDNPwd = password123
    Suffix = dc=example,dc=com
    UseExistingMC = 1
    AddSampleEntries = No


Notes
------

Be sure the Primary is up-and-running before you kickstart the Secondar(y\|ies). As the last step is to register themselves with the Configuration Admin Server, and that will silently fail unless it is available.

