# oci-lab-ocne-gluster
Automation to set up OCNE in Oracle provided free lab environment (https://luna.oracle.com/lab/5455954d-142c-4801-9f34-5946ad19573d?ojr=lab%3Blid%3D5455954d-142c-4801-9f34-5946ad19573d)

At the time this code was created the lab timeslot is limited to 1 hour and 30 minutes, which lead me to automate these tasks.
Setting up the underlying ocne cluster as pre-requisite is part of the free lab provisioning process and takes approximately 25-30 minutes to finish after launch.

This automation is best executed within the Luna Lab environment using Visual Studio Code.

# Pre-Requisites on the local execution machine:
- git client, ansible installed
    - verify with ```git version```and ```ansible --version```

# Instructions to setup

1. Launch Lab

    1.1. In Lab Environment click on "Luna Lab" ... wait until Resources are provisioned. Click "Resources" Tab to gather IP addresses for ocne-operator, ocne-control and ocne-worker nodes

2. Checkout this git repo in Luna Lab Visual Studio Code

    2.1 Open Visual Studio Code. Select Topmost left Icon ("Explorer") and press "Clone Repository" button.
    Provide github URL: https://github.com/lschubert/oci-lab-ocne-gluster.git
    Select "Open Folder" and choose the local path of cloned repo

3. In Lab Environement Visual Studio Code

    3.1. Select "Terminal > New Terminal"
    
        Hint: Minimize Browser window with Luna Lab
    
    3.2. Set Environment variables

    HEKETI_ADMIN_PASS is used to manage the Heketi Topology for Gluster
    ```
    export HEKETI_ADMIN_PASS=<password>
    export HEKETI_USER_PASS=<password>
    ```

    3.3. In oci-lab-ocne folder execute ```./setup.sh```

# About this Luna Lab environment

1. Each worker node has an additional 50GB Block device attached for Gluster setup

# Developer ToDo's:
kubectl get no -ocustom-columns=Name:metadata.name,Status:status.conditions[-1].type
must be all nodes ready
Example:

Name             Status
ocne-control01   Ready
ocne-worker01    Ready
ocne-worker02    Ready
ocne-worker03    Ready