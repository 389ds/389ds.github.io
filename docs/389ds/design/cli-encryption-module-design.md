---
title: "CLI Manage Encryption Modules Design"
---

# CLI Manage Encryption Modules Design
----------------

Overview
--------

There is no way to manage additional encryption modules in the CLI. If you want have multiple server certificates with different keys you have to manually add encryption module entries under **cn=encryption,cn=config**

Use Cases
---------

Common use cases are if you want to have the server accept both RSA and ML-DSA-87 (PQC) certificates

Design
------

Created new options for **dsconf** and **dsctl** to handle encryption modules and multiple server certificates. Previously we hardcoded **Server-Cert** as the only certificate the server would manage.  Now you can specify the certificate name when importing certificates, etc.

### dsconf

```
dsconf [instance] security encryption-module {add,delete,edit,list,get} ...

positional arguments:
  {add,delete,edit,list,get}
                        encryption-module
    add                 Add an encryption module
    delete              Delete an encryption module
    edit                Edit an encryption module
    list                List encryption modules
    get                 Get an encryption module
```

#### Add

```
dsconf [instance] security encryption-module add --cert-nickname CERT_NICKNAME [--activated] [--token TOKEN] [--server-key-extract-file SERVER_KEY_EXTRACT_FILE]
                                                 [--server-cert-extract-file SERVER_CERT_EXTRACT_FILE] 
                                                 name

Add a new encryption module to the encryption module list.

positional arguments:
  name                  The name of the encryption module

options:
  --cert-nickname CERT_NICKNAME
                        The personality or nickname of the server certificate
  --activated           Activate the encryption module.
  --token TOKEN         The token of the encryption module. Default is "internal (software)".
  --server-key-extract-file SERVER_KEY_EXTRACT_FILE
                        The file name of the server key extract file
  --server-cert-extract-file SERVER_CERT_EXTRACT_FILE
                        The file name of the server cert extract file
```

#### Delete

```
dsconf instance security encryption-module delete name

Delete an encryption module from the encryption module list.

positional arguments:
  name        The name of the encryption module
```

#### Edit

```
dsconf [instance] security encryption-module edit [--cert-nickname CERT_NICKNAME] [--activate] [--deactivate] [--token TOKEN] [--server-key-extract-file SERVER_KEY_EXTRACT_FILE]
                                                  [--server-cert-extract-file SERVER_CERT_EXTRACT_FILE]
                                                  name

Edit an encryption module in the encryption module list.

positional arguments:
  name                  The name of the encryption module

options:
  --cert-nickname CERT_NICKNAME
                        The personality or nickname of the server certificate
  --activate            Activate the encryption module
  --deactivate          Deactivate the encryption module
  --token TOKEN         The token of the encryption module.
  --server-key-extract-file SERVER_KEY_EXTRACT_FILE
                        The file name of the server key extract file
  --server-cert-extract-file SERVER_CERT_EXTRACT_FILE
                        The file name of the server cert extract file
```

#### List

```
dsconf instance security encryption-module list [--just-names]

List all encryption modules in the encryption module list.

options:
  --just-names  Just list the modules by its name and not the full entry
```

#### Get

```
dsconf instance security encryption-module get name

Get an encryption module from the encryption module list.

positional arguments:
  name        The name of the encryption module
```

### dsctl

These **dsctl** commands now accept a nickname to specify what certificate to act upon.  If the nickname is omitted then **Server-Cert** is the default value

```
dsctl [instance] tls show-server-cert [--nickname NICKNAME]
dsctl [instance] tls import-server-cert [--nickname NICKNAME] cert_path
dsctl [instance] tls import-server-key-cert [--nickname NICKNAME] cert_path key_path
dsctl [instance] tls generate-server-cert-csr [--subject SUBJECT] [--nickname NICKNAME] [alt_names ...]

```

Major configuration options and enablement
------------------------------------------

Changes made to an encryption module requires a server restart to take effect

Origin
-------------

<https://github.com/389ds/389-ds-base/issues/7281>

Author
------

<mreynolds@redhat.com>

