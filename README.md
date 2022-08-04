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

2. During setup.sh automation 5 PVCs will be created with 1GB each

3. For validation of proper use an nginx deployment will use one of the PVCs (gluster-pvc-1)

# Use Cases

1. Access Kubernetes Dashboard

    1.1. Start kubernetes proxy on ocne-control
    
    ```
    [oracle@ocne-control ~]$ kubectl proxy
    Starting to serve on 127.0.0.1:8001

    ```

    1.2. Enable port forwarding for remote connection (only for demo purposes)

    ```
    [luna.user@lunabox oci-lab-ocne]$ ssh -L 8001:127.0.0.1:8001 ocne-control
    Activate the web console with: systemctl enable --now cockpit.socket

    Last login: Fri Jul 29 11:01:48 2022 from 147.154.151.58
    [oracle@ocne-control ~]$
    ```

    1.3. Obtain Login Token on ocne-control

    ```
    [oracle@ocne-control ~]$ kubectl -n kube-system get $(kubectl -n kube-system \
     get secret -n kube-system -o name | grep namespace) -o jsonpath='{.data.token}’

    eyJhbGciOiJSUzI1NiIsImtpZCI6IkltQkFoYzVCU0FUSzlESlNYWW9yTUluSmo3aUs3d1BfbEw3SGFwWXJmb28ifQ.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZ……
    QEzli5QmUA
    ```

    1.4. Open Kubernetes Dashboard in Luna Lab browser (Google Chrome)

    URL: http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
    
    Choose Token and paste the token from previous step to log in


# Developer ToDo's:
