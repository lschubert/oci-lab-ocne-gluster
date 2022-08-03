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

    1.1. In Lab Environment click on "Luna Lab" ... wait until Resources are provisioned. Click "Resources" Tab to gather IP addresses for ocne-operator, ocne-control01, ocne-worker01, ocne-worker02 and ocne-worker03 nodes

2. Checkout this git repo in Luna Lab Visual Studio Code

    2.1 Open Visual Studio Code. Select Topmost left Icon ("Explorer") and press "Clone Repository" button.
    Provide github URL: https://github.com/lschubert/oci-lab-ocne-gluster.git
    Select "Open Folder" and choose the local path of cloned repo

3. In Lab Environement Visual Studio Code

    3.1. Open file ```vars/main.yml``` in Visual Studio Code and modify the values for ```ocne_control_ip```, ```ocne_operator_ip``` and ```ocne_worker_ip``` to match the corresponsing IPs from step 1.1

    3.2. Make sure "oci_executor" variable in ```vars/main.yml``` is set to true 

    3.3. Select "Terminal > New Terminal"
    
    3.4. Set Environment variables

    HEKETI_ADMIN_PASS is used to manage the Heketi Topology for Gluster
    ```
    export HEKETI_ADMIN_PASS=<password>
    export HEKETI_USER_PASS=<password>
    ```

    3.3. In oci-lab-ocne-gluster folder execute ```./setup.sh```

# About this Luna Lab environment

1. Each worker node has an additional 50GB Block device attached for Gluster setup

# Developer ToDo's:

[oracle@ocne-control01 ~]$ kubectl get pvc -owide
NAME            STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS     AGE   VOLUMEMODE
gluster-pvc-0   Pending                                      hyperconverged   12m   Filesystem
gluster-pvc-1   Pending                                      hyperconverged   12m   Filesystem
gluster-pvc-2   Pending                                      hyperconverged   12m   Filesystem
gluster-pvc-3   Pending                                      hyperconverged   12m   Filesystem
gluster-pvc-4   Pending                                      hyperconverged   12m   Filesystem
gluster-pvc-5   Pending                                      hyperconverged   12m   Filesystem
[oracle@ocne-control01 ~]$ kubectl describe pvc gluster-pvc-0 
Name:          gluster-pvc-0
Namespace:     default
StorageClass:  hyperconverged
Status:        Pending
Volume:        
Labels:        <none>
Annotations:   volume.beta.kubernetes.io/storage-provisioner: kubernetes.io/glusterfs
               volume.kubernetes.io/storage-provisioner: kubernetes.io/glusterfs
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      
Access Modes:  
VolumeMode:    Filesystem
Used By:       <none>
Events:
  Type     Reason              Age                 From                         Message
  ----     ------              ----                ----                         -------
  Warning  ProvisioningFailed  89s (x12 over 12m)  persistentvolume-controller  Failed to provision volume with StorageClass "hyperconverged": failed to create volume: failed to create volume: see kube-controller-manager.log for details