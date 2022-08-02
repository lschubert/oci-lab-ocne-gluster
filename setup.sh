#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook setup.yml
#ansible-playbook -i ./hosts setup.yml