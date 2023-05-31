---
title: "Container Integration"
---

## Overview of Container Administration

Containers, especially docker and related implementations are an important and modern way of
deploying applications. Their value is primarily in the fact that they are staticly-linked
application distribution, allowing the developer, qe and administrator to guarantee that they
are using the same software with the same integration points.

Other important aspects of containers is that they represent the first time a highly accessible
and usable interface to complex linux technologies is available. For example, SELinux is
notorious for it's complexity, yet docker makes it trivial to run with a well confined application
within the container. Similar are cgroups for resource limits, storage allocation, and application
migration.

Containers are built on a build server, transported to the consumer, and deployed. A common
deployment pattern is for example:

	docker run -p 8080:8080 my_awesome_webservice

It's important to note here that docker is the arbitrator of all resources - in this case host
port 8080 is connected to the containers port 8080. The container will only see traffic
from the host, as the host is proxying connections through.

To configure our webservice, we pass in environment variables. For example:

	docker run -p 8080:8080 -e ADMIN_NAME=claire my_awesome_webservice

Another example of running docker applications is

	docker create -p 5432:5432 -v pgsql_data:/data pgsql:latest
	docker start <instance name>

Here we see a container instance created from the pgsql latest image, and it has storage
connected to "/data". The location of "pgsql_data" is unknown to us the admin, but it's
a named resource so can be reused. The instance is then started.

Say we wanted to "upgrade" the instance. We would do:

	docker pull pgsql:latest
	docker rm <instance name>
	docker create -p 5432:5432 -v pgsql_data:/data pgsql:latest
	docker start <new instance name>

See how we delete and create a new instance, but we provide the same named storage? This is how
upgrades are performed, where persistent data is given to the new container.

Key themes - upgrades are unknown to the container. Only data is passed in, and we have that
as our only source of state. Resources are arbitrated to us. Hostnames and dynamic. Network
traffic is proxied. Configuration is from environment (or our volume state).

## 389 Directory Server Challenges

389 DS has a large number of challenges in this environment. DS is designed in a way that
requires it to be bootstrapped (dscreate), it uses dynamic config in /etc, it has data
in multiple locations in /var, and it requires a low numbered port (containers can't access
things as root!).

In the past we also assumed that rpm scripts were run for upgrades and data migrations
which requires state. Finally some operations even assume local access.

As a result 389 looks pretty hard to containerise!

## Integration design

Thankfully, most of the work is already done. The end result will a container that works such as:

	docker run -p 389:3389 -p 636:3636 -v 389_data:/data 389ds:latest

When the container is run, we enter an entry point (dscontainer) which understands and knows how
to run in containers. First, it establishes all the locations in /data if they are required. Then
it checks if an instance exists. If it exists, we simply start it. If no instance exists, one is
created into /data. Special symlinks are added in /etc/ to allow the config to be redirected into
/data.

The created instance has *no* suffix by default because we don't know what suffix the user may want.
We just don't have the information available.

The dscontainer tool also does a number of helpful things in the setup process. It disable selinux
and systemd integration since a container requires none of this. It disable hostname checks because
containers use dynamic hostnames. It also acts as a proper init process, able to proxy the signals
like sigterm etc to the running process for shutdowns and waiting until the processes are re-attached
.

In environments like kubernetes, users and groups are dynamically assigned to the storage and running
user, so the dscontainer tool also handles this correctly by setting the running user/group in
the setup process. This requires testing to be sure it works.

In the future, the dscontainer tool should proxy environment variables into the dse.ldif before
startup. This way DS can be configured with docker native behaviours. Some examples are
the directory manager password, replication password, indexing on startup.

## Future integration goals

* Support kubernetes autoscaling for replicas (should be read-only replicas here)
* Support "replication" configuration on startup
* Support adding a suffix on startup
* Pass through environment variables for root user password
* Add a proper way to determine container health
* Add a method to show the container is ready to process requests (similar to a status page in HTTP)
* Potentially change dsctl to block all local actions if container flag found
* Start container with -D instead of assuming hard-set /etc path
* Configure the TLS path different in container

## Frequent questions about design choices

### Can I change the instance name?

No - the instance name is to allow multiple LDAP servers on a single host. Because docker isolates
all our instances, the isolation is provided by docker. So changing the instance name "does nothing"
and in fact would make building the image potentially more complex. As a result, we leave it as
localhost and be done.

### How can I add name the suffix?

Well, naming the suffix would mean we *have* one in a container - by default because we don't know
what you want to do, we don't supply a suffix in the container, you need to add one with dsconf.
However, in the future we could automate a suffix creation as part of environment configuration
to allow automated setup of replication and suffix as part of the containers.

### How can I administer the instance?

You should use dsconf and dsidm via the remote ldap port. If that fails, you may need to use
docker exec -i -t [name of container instance] dsconf .... instead.

### Can I use cockpit with the container?

This is not possible due to how cockpit works - cockpit expects a systemd instance and a running
server with command line. We don't ship an init system so we have no way to launch cockpit inside
of the container with the ldap server. As a result, we recommend you use the cli tools.

### How can I tune my directory for ...

You don't have to! 389 fully supports auto-tuning inside of docker, even if you provide docker
memory and cpu limits, we respect and scale to them.

## Other integrations that made this possible

Many other pieces have been put into place in the last 2 years before this. Examples are:

* defaults.inf to allow discovery of resources for cli tools
* allowing to run with zero suffixes in the server (it used to crash)
* python installer is an api framework, not a tool-only so easier to integrate
* python tools allow decoupling from systemd/selinux, and configuring a lot in setup
* cn=config removes most options and transparent upgrades from libglobs.c
* probably many more that I have forgotten ...

