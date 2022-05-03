---
title: "Deploying 389 Directory Server on OpenShift"
---

Deploying 389 Directory Server on OpenShift
===========================================
{% include toc.md %}

## Overview

This document describes the process of deploying 389 Directory Server in a container on OpenShift.

The container images that were tested on OpenShift are available at [quay.io/389ds/dirsrv](https://quay.io/repository/389ds/dirsrv?tab=tags).

Available tags:
* `quay.io/389ds/dirsrv:latest` - based on latest version of Fedora
* `quay.io/389ds/dirsrv:c9s` - based on latest version of CentOS 9 Stream

## Environment variables

* `DS_DM_PASSWORD` - set `cn=Directory Manager`'s password
* `DS_ERRORLOG_LEVEL` - set the log level for `ns-slapd`, default is 266354688.
* `DS_MEMORY_PERCENTAGE` - set LDBM autotune percentage (`nsslapd-cache-autosize`), default is 25.
* `DS_REINDEX` - run database reindex task (`db2index`).
* `DS_STARTUP_TIMEOUT` - set container startup timeout in seconds, default is 60 seconds.
* `DS_SUFFIX_NAME` - use suffix as a basedn in `dsrc` file, default one is derived from the hostname.

## Important notes

* All state is stored in `/data`. A new empty database will be created every time the pod is restarted, unless an existing configuration is present in `/data`.
* No backends or suffixes are created by default. They can be created later, once the instance is initialized.
* A single instance named `localhost` is created.
* The `cn=Directory Manager`'s password is randomized on install and can be viewed in the setup log. It can be set to a preferred password using `DS_DM_PASSWORD` environment variable.
* By default the container will use a self-signed CA certificate and a server certificate signed by that CA.
* Custom TLS certificate and key should be placed in `/data/tls/server.crt` and `/data/tls/server.key`, respectively.
* CA certificates should be placed under `/data/tls/ca/` in separate files, i.e. `/data/tls/ca/ca1.crt`, `/data/tls/ca/ca2.crt`, etc.
* `ns-slapd` is running on ports 3389 and 3636 inside the pod.
* Scaling `StatefulSet` doesn't automatically setup replication between the instances.

## Deploying 389 Directory Server container

Sample configuration

* `svc-internal.yaml`
  
```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: dirsrv
  name: dirsrv-internal-svc
spec:
  clusterIP: None
  ports:
  - name: dirsrv-nonsecure
    port: 3389
    protocol: TCP
    targetPort: 3389
  - name: dirsrv-secure
    port: 3636
    protocol: TCP
    targetPort: 3636
  selector:
    app: dirsrv
  type: ClusterIP
status:
  loadBalancer: {}
```

* `svc-external.yaml`
  
```yaml
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: dirsrv
  name: dirsrv-external-svc
spec:
  ports:
  - name: dirsrv-nonsecure
    port: 3389
    protocol: TCP
    targetPort: 3389
    nodePort: 30389
  - name: dirsrv-secure
    port: 3636
    protocol: TCP
    targetPort: 3636
    nodePort: 30636
  selector:
    app: dirsrv
  type: NodePort
status:
  loadBalancer: {}
```

* `dirsrv-statefulset.yaml`

```yaml
kind: StatefulSet
apiVersion: apps/v1
metadata:
  name: dirsrv
spec:
  serviceName: dirsrv-internal-svc
  replicas: 1
  selector:
    matchLabels:
      app: dirsrv
  template:
    metadata:
      labels:
        app: dirsrv
    spec:
      serviceAccountName: dirsrv-sa
      initContainers:
      # Init container is required to change the permissions after a persistent volume is mounted.
      # Otherwise dscontainer will be denied to create subdirectories and will fail to start.
      - name: dirsrv-init-container
        image: busybox
        command: ["sh", "-c", "chown -R 389:389 /data"]
        volumeMounts:
        - name: dirsrv-data
          mountPath: /data
      containers:
        - name: dirsrv-container
          image: quay.io/389ds/dirsrv:latest
          env:
          ## Set `cn=Directory Manager`'s password
          #- name: DS_DM_PASSWORD
          #  valueFrom:
          #    secretKeyRef:
          #      name: dirsrv-dm-password
          #      key: dm-password
          ## Use suffix as a basedn in `dsrc` file
          # - name: DS_SUFFIX_NAME
          #   value: "dc=example,dc=com"
          ## DS_ERRORLOG_LEVEL - set the log level for `ns-slapd`, default is 266354688
          # - name: DS_ERRORLOG_LEVEL
          #   value: "8192"
          ## DS_MEMORY_PERCENTAGE - set LDBM autotune percentage (`nsslapd-cache-autosize`), default is 25
          #- name: DS_MEMORY_PERCENTAGE
          #  value: "10"
          ## DS_REINDEX` - run database reindex task (`db2index`)
          # - name: DS_REINDEX
          #   value: "True"
          ## DS_STARTUP_TIMEOUT - set container startup timeout in seconds, default is 60 seconds.
          # - name: DS_STARTUP_TIMEOUT
          #   value: "120"
          ports:
            - containerPort: 3389
              protocol: TCP
              port: 389
            - containerPort: 3636
              protocol: TCP
              port: 636
          securityContext:
            runAsUser: 389
            fsGroup: 389
          volumeMounts:
          - name: dirsrv-data
            mountPath: "/data"
          - name: dirsrv-tls
            mountPath: '/data/tls/'
            readOnly: true
          - name: dirsrv-tls-ca
            mountPath: '/data/tls/ca'
            readOnly: true
      volumes:
      - name: dirsrv-tls
        secret:
          secretName: dirsrv-tls-secret
          items:
          - key: tls.key
            path: server.key
          - key: tls.crt
            path: server.crt
      - name: dirsrv-tls-ca
        secret:
          secretName: dirsrv-tls-ca
          items:
          - key: ca1.crt
            path: ca1.crt
          - key: ca2.crt
            path: ca2.crt
  volumeClaimTemplates:
  - metadata:
      name: dirsrv-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 10Gi
```


Create a new project:
```
oc new-project demo 
```

Create a service account for dirsrv and grant anyuid SCC: 
```
oc create serviceaccount dirsrv-sa
oc adm policy add-scc-to-user anyuid -n demo -z dirsrv-sa
```

Create internal and external services:
```
oc apply -f svc-internal.yaml
oc apply -f svc-external.yaml
```

You should see something like this:
```
$ oc get svc
NAME                  TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                         AGE
dirsrv-external-svc   NodePort    172.30.204.84   <none>        3389:30389/TCP,3636:30636/TCP   4s
dirsrv-internal-svc   ClusterIP   None            <none>        3389/TCP,3636/TCP               7s
```

And create routes for them:
```
oc expose svc dirsrv-external-svc
oc expose svc dirsrv-internal-svc
```

```
$ oc get routes
NAME                  HOST/PORT                                        PATH   SERVICES              PORT               TERMINATION   WILDCARD
dirsrv-external-svc   dirsrv-external-svc-demo.apps.cliuster.domain.tld          dirsrv-external-svc   dirsrv-nonsecure                 None
dirsrv-internal-svc   dirsrv-internal-svc-demo.apps.cliuster.domain.tld          dirsrv-internal-svc   dirsrv-nonsecure                 None
```

Create TLS and CA secrets:
```
oc create secret tls dirsrv-tls-secret --cert=/path/to/tls.cert --key=/path/to/tls.key
oc create secret generic dirsrv-tls-ca --from-file=/path/to/ca1.crt --from-file=/path/to/ca2.crt
```

(Optionally) Create a secret with Directory Manager's password:
```
oc create secret generic dirsrv-dm-password --from-literal=dm-password='Secret123'
```
Create `StatefulSet` for 389 Directory Server:
```
os apply -f dirsrv-statefulset.yaml
```

A newly deployed 389 Directory Server should be up and running. You can check that it is accessible by running `ldapsearch` from inside the cluster:

```
$ oc run ldap-client --rm -it --image=quay.io/vashirov/ds:client -- bash
If you don't see a command prompt, try pressing enter.
[root@ldap-client /]# ldapsearch -xLLL -H ldap://dirsrv-internal-svc.demo.svc.cluster.local:3389 -b "" -s base
dn:
objectClass: top
netscapemdsuffix: cn=ldap://dc=dirsrv-0,dc=dirsrv-internal-svc,dc=demo,dc=svc,
 dc=cluster,dc=local:3389
```

And outside of the cluster:
```
$ ldapsearch -xLLL -H ldap://dirsrv-external-svc-demo.apps.cliuster.domain.tld:30389 -b "" -s base
dn:
objectClass: top
netscapemdsuffix: cn=ldap://dc=dirsrv-0,dc=dirsrv-internal-svc,dc=demo,dc=svc,
 dc=cluster,dc=local:3389
```

Using LDAPS:
```
$ ldapsearch -xLLL -H ldaps://dirsrv-external-svc-demo.apps.cliuster.domain.tld:30636 -b "" -s base
dn:
objectClass: top
netscapemdsuffix: cn=ldap://dc=dirsrv-0,dc=dirsrv-internal-svc,dc=demo,dc=svc,
 dc=cluster,dc=local:3389
```

## Configuration
After pod is deployed, all configuration can be done using `dsctl` and `dsconf` by running them inside the pod. They talk to the server via ldapi socket.

The following example will create a new backend and suffix, and will set up replication between the servers. 

First, scale the stateful set, so that 2 pods will be running:

```
oc scale statefulset dirsrv --replicas=2
```

Create backend and suffix
```
oc exec -ti dirsrv-0 -- dsconf localhost backend create --suffix dc=example,dc=com --be-name userroot --create-suffix --create-entries 
oc exec -ti dirsrv-1 -- dsconf localhost backend create --suffix dc=example,dc=com --be-name userroot --create-suffix --create-entries 
```

Enable replication
```

oc exec -ti dirsrv-0 -- dsconf localhost replication enable --suffix dc=example,dc=com --role=supplier --replica-id 1
oc exec -ti dirsrv-1 -- dsconf localhost replication enable --suffix dc=example,dc=com --role=supplier --replica-id 2
```

Create replication manager accounts
```
oc exec -ti dirsrv-0 -- dsconf localhost replication create-manager --name rmanager --passwd password --suffix dc=example,dc=com 
oc exec -ti dirsrv-1 -- dsconf localhost replication create-manager --name rmanager --passwd password --suffix dc=example,dc=com 
```

Create replication agreements
```
oc exec -ti dirsrv-0 -- dsconf localhost repl-agmt create --suffix dc=example,dc=com --bind-dn cn=rmanager,cn=config --bind-passwd password --bind-method SIMPLE --conn-protocol LDAP --host dirsrv-1.dirsrv-internal-svc.demo.svc.cluster.local --port 3389 meTo1

oc exec -ti dirsrv-1 -- dsconf localhost repl-agmt create --suffix dc=example,dc=com --bind-dn cn=rmanager,cn=config --bind-passwd password --bind-method SIMPLE --conn-protocol LDAP --host dirsrv-0.dirsrv-internal-svc.demo.svc.cluster.local --port 3389 meTo0 
```

Initialize replication agreements
```
oc exec -ti dirsrv-0 -- dsconf localhost repl-agmt init meTo1 --suffix dc=example,dc=com
oc exec -ti dirsrv-1 -- dsconf localhost repl-agmt init meTo0 --suffix dc=example,dc=com
```

Add a user:

```
oc exec -ti dirsrv-0 -- dsidm localhost --basedn dc=example,dc=com user create --uid ldap_user --cn ldap_user --displayName ldap_user --uidNumber 1001 --gidNumber 1001 --homeDirectory /home/ldap_user
```

Reset their password:

```
oc exec -ti dirsrv-0 -- dsidm localhost --basedn dc=example,dc=com account change_password uid=ldap_user,ou=people,dc=example,dc=com
```

And check if the user was replicated to the second server:

```
oc exec -ti dirsrv-1 -- dsidm localhost --basedn dc=example,dc=com user list
demo_user
ldap_user
```

Try logging in as a new user:
```
$ ldapwhoami -x -H ldaps://dirsrv-external-svc-demo.apps.cliuster.domain.tld:30636 -D "uid=ldap_user,ou=people,dc=example,dc=com" -w password
dn: uid=ldap_user,ou=people,dc=example,dc=com
```


