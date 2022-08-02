# oci-lab-ocne-gluster
Automation to set up OCNE in Oracle provided free lab environment (https://luna.oracle.com/lab/5455954d-142c-4801-9f34-5946ad19573d?ojr=lab%3Blid%3D5455954d-142c-4801-9f34-5946ad19573d)

At the time this code was created the lab timeslot is limited to 1 hour and 30 minutes, which lead me to automate these tasks.
Setting up the underlying ocne cluster as pre-requisite is part of the free lab provisioning process and takes approximately 25-30 minutes to finish after launch.

This automation is best executed within the Luna Lab environment using Visual Studio Code.

# Pre-Requisites on the local execution machine:
- git client, ansible installed
    - verify with ```git version```and ```ansible --version```


# Developer ToDo's:
kubectl get no -ocustom-columns=Name:metadata.name,Status:status.conditions[-1].type
must be all nodes ready
Example:

Name             Status
ocne-control01   Ready
ocne-worker01    Ready
ocne-worker02    Ready
ocne-worker03    Ready