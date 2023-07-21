---
title:  "How to run lib389 in a Jenkins Job"
---

{% include toc.md %}

# How to run lib389 in a Jenkins Job
------------

### Prerequisites

-   Disable selinux
-   Enable the "sendmail" service so email notifications can be sent
-   Install the required python packages:
    - python-pip
    - python-virtualenv
    - python-ldap
    - python-pyasn1
    - python-pyasn1-modules
    - pytest


            yum install python-pip python-virtualenv python-ldap python-pyasn1 python-pyasn1-modules pytest

### Jenkins Setup

-   Create a new job
-   Add "Build Step" -->  "Execute Shell"  -->  Specify location of your shell script
-   Add email notifications:  "Add post-build action"  --> email notification


### Example Jenkins Job Script

This script install python p[ip environment, checks out a fresh copy of the Directory Server source code, builds & installs the server binaries into a isolated location that will not interfere with any existing Directory Server binaries & installations, and then runs the lib389 ticket test scripts.



    #!/bin/sh

    #
    # Jenkins script to execute the lib389 testcases located in the
    # the Directory Server source tree (main branch)
    #

    #
    # Create the requirements file for pip
    #
    REQ="python-ldap\npyasn1\npyasn1-modules\nwheel\nnose\n"
    echo -e $REQ > $WORKSPACE/requirements.txt

    #
    # Setup pip
    #
    echo Setting up pip...

    PATH=$WORKSPACE/venv/bin:/usr/local/bin:$PATH
    if [ ! -d "venv" ]; then
            virtualenv venv
    fi
    . venv/bin/activate
    pip install --upgrade pip
    pip install pyopenssl ndg-httpsclient pyasn1
    pip install requests==2.5.3
    pip install --pre --upgrade -r $WORKSPACE/requirements.txt
    git clone https://github.com/389ds/389-ds-base.git
    pip --cert /etc/pki/tls/cert.pem install 389-ds-base/src/lib389
    . venv/bin/activate

    #
    # Create our directories for DS
    #
    echo Preparing Directory Server build/install environment...

    INSTALL_PREFIX=$WORKSPACE/ci-install
    mkdir $WORKSPACE/source
    mkdir $WORKSPACE/../../../.dirsrv
    cd $WORKSPACE/source

    #
    # Get the source code
    #
    echo Checking out the Directory Server source code...

    git clone https://github.com/389ds/389-ds-base.git
    cd ds
    git checkout main
    cd ..

    #
    # Build the server
    #
    echo Building the server...

    mkdir $INSTALL_PREFIX
    mkdir BUILD
    cd BUILD
    CFLAGS='-pipe -fexceptions -fstack-protector --param=ssp-buffer-size=4  -m64 -mtune=generic' CXXFLAGS='-pipe -fexceptions -fstack-protector --param=ssp-buffer-size=4 -m64 -mtune=generic' ../ds/configure --enable-autobind --with-selinux --with-openldap  --prefix=$INSTALL_PREFIX
    make install > /dev/null

    #
    # Run the lib389 tests
    #
    echo Run the lib389 tests...

    cd ../ds/dirsrvtests/tickets
    DATE=`date`
    RESULT=`PREFIX=$INSTALL_PREFIX py.test -v -x`
    if [ $? -ne 0 ]; then
        echo CI Tests FAILED!
        echo $TEST_RESULT
        MSG="FAILED"
        RC=1
    else
        echo CI tests PASSED...
        MSG="PASSED"
        RC=0
    fi

    #
    # Email the result (optional)
    #
    sendmail -f mareynol@redhat.com mareynol@redhat.com <<EOF
    subject: Nightly Upstream CI Testing Result: $MSG
    $DATE
    $RESULT
    EOF

    #
    # Cleanup
    #
    /usr/bin/rm -rf $INSTALL_PREFIX
    /usr/bin/rm -rf $WORKSPACE/source
    /usr/bin/rm -rf $WORKSPACE/../../../.dirsrv

    exit $RC
