# oci-lab-ocne-gluster
Automation to set up OCNE in Oracle provided free lab environment (https://luna.oracle.com/lab/5455954d-142c-4801-9f34-5946ad19573d?ojr=lab%3Blid%3D5455954d-142c-4801-9f34-5946ad19573d)

At the time this code was created the lab timeslot is limited to 1 hour and 30 minutes, which lead me to automate these tasks.
Setting up the underlying ocne cluster as pre-requisite is part of the free lab provisioning process and takes approximately 25-30 minutes to finish after launch.

This automation is best executed within the Luna Lab environment using Visual Studio Code.

# Pre-Requisites on execution machine:
- git client, ansible installed
    - verify with ```git version``` and ```ansible --version```

# Instructions to setup

1. Launch Lab

    1.1. In Lab Environment click on "Luna Lab" ... wait until Resources are provisioned. Click "Resources" Tab to gather IP addresses for ocne-operator, ocne-control01, ocne-worker01, ocne-worker02 and ocne-worker03 nodes

2. Checkout this git repo in Luna Lab Visual Studio Code

    2.1 Open Visual Studio Code. Select Topmost left Icon ("Explorer") and press "Clone Repository" button.
    Provide github URL: https://github.com/lschubert/oci-lab-ocne-gluster.git
    Select "Open Folder" and choose the local path of cloned repo

3. In Lab Environement Visual Studio Code

    3.1. Select "Terminal > New Terminal"

    3.2.  In Temrinal Window - gather ip addresses from lab enviroment
    ```
    ./get_ips.sh
    ocne_control_ip: 129.159.255.204
    ocne_operator_ip: 138.2.174.20
    ocne_worker_ip: 
      - 141.147.16.66
      - 141.147.22.154
      - 138.2.145.19
    ``` 

    3.3. Open file ```vars/main.yml``` in Visual Studio Code and modify the values for ```ocne_control_ip```, ```ocne_operator_ip``` and ```ocne_worker_ip``` to match the corresponsing IPs from step 3.2

    You can copy the output from ```./get_ips.sh``` and replace the corresponding section at the beginning of ```vars/main.yml```

    3.4. Make sure "oci_executor" variable in ```vars/main.yml``` is set to true 

    Save the file.
    
    3.5. In Terminal Window - Set Environment variables

    HEKETI_ADMIN_PASS is used to manage the Heketi Topology for Gluster
    ```
    export HEKETI_ADMIN_PASS=<password>
    export HEKETI_USER_PASS=<password>
    ```

    3.6. Wait until Lab resoources are fully deployed. This can be checked in Luna Lab Web Site under Resources Tab.

    The provosioning process is complete once IP Adresses for VMs are displayed under Resources Tab.
    
    3.7. In oci-lab-ocne-gluster folder execute ```./setup.sh```

    The automation triggered by ```./setup.sh``` is expected to be idempotent. You can change variables or the automation code itself and re-run the ```./setup.sh``` to reconfigure the setup (e.g. to enable or disable OCNE modules)

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

# Development info

The following features are under development and in experimental state:

* istio module configuration

## Contribution 

I am happy and open to contributors. If you feel something is going wrong with this lab automation or you have an idea to add as use case, feel free to create a feature branch from master branch, implement and commit the stuff you want to contribute to that feature branch and create a pull request towards master branch.

While implementing this code I am applying the following principles which I would encourage to be adopted by contributors as well

* Code the automation with idempotency in mind. Automation must be executable again and again with delivering the expected outcome.
* Ease of use. Using the code should be as simple as possible with least necessary steps to describe but yet flexible to configure where needed. 
* There is no perfect code. Just do it the right way
* If the usage pattern changes, do not forget to update the documentation (this README)

## Istio Deployment

[oracle@ocne-control01 ~]$ kubectl get deployment -n istio-system
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
grafana                1/1     1            1           58m
istio-egressgateway    0/2     2            0           58m
istio-ingressgateway   0/2     2            0           58m
istiod                 2/2     2            2           58m
prometheus-server      1/1     1            1           58m

-> istio-egressgateway and istio-ingressgateway are not running

[oracle@ocne-control01 ~]$ kubectl logs -n istio-system istio-egressgateway-555859d8fd-bgnz9
...
2022-08-04T14:30:30.966702Z     warning envoy config    StreamAggregatedResources gRPC config stream closed since 749s ago: 14, connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: i/o timeout"
2022-08-04T14:31:15.130536Z     warning envoy config    StreamAggregatedResources gRPC config stream closed since 793s ago: 14, connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: i/o timeout"
2022-08-04T14:32:04.309633Z     warning envoy config    StreamAggregatedResources gRPC config stream closed since 842s ago: 14, connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: i/o timeout"
2022-08-04T14:32:32.587799Z     warn    ca      ca request failed, starting attempt 1 in 104.968012ms
2022-08-04T14:32:32.693459Z     warn    ca      ca request failed, starting attempt 2 in 209.862201ms
2022-08-04T14:32:32.903733Z     warn    ca      ca request failed, starting attempt 3 in 372.473859ms
2022-08-04T14:32:33.277322Z     warn    ca      ca request failed, starting attempt 4 in 807.298401ms
2022-08-04T14:32:34.085280Z     warn    sds     failed to warm certificate: failed to generate workload certificate: create certificate: rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: i/o timeout"
...


[oracle@ocne-control01 ~]$ kubectl logs -n istio-system istio-ingressgateway-fb6d76584-2s7sl
...
2022-08-04T14:35:43.686957Z     warning envoy config    StreamAggregatedResources gRPC config stream closed since 1062s ago: 14, connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: i/o timeout"
2022-08-04T14:36:16.628171Z     warning envoy config    StreamAggregatedResources gRPC config stream closed since 1095s ago: 14, connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: i/o timeout"
2022-08-04T14:36:48.909073Z     warning envoy config    StreamAggregatedResources gRPC config stream closed since 1127s ago: 14, connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: i/o timeout"
2022-08-04T14:36:53.017326Z     warn    ca      ca request failed, starting attempt 1 in 98.193019ms
2022-08-04T14:36:53.115626Z     warn    ca      ca request failed, starting attempt 2 in 183.794579ms
2022-08-04T14:36:53.300055Z     warn    ca      ca request failed, starting attempt 3 in 428.018137ms
2022-08-04T14:36:53.728760Z     warn    ca      ca request failed, starting attempt 4 in 730.909369ms
2022-08-04T14:36:54.460798Z     warn    sds     failed to warm certificate: failed to generate workload certificate: create certificate: rpc error: code = Unavailable desc = connection error: desc = "transport: Error while dialing dial tcp 10.109.4.175:15012: connect: connection timed out"
...

### Grafana Dashboard not accessible

following https://docs.oracle.com/en/operating-systems/olcne/1.5/mesh/grafana.html#ip

- Verify if LabEnv has ocne 1.5 pre-installed