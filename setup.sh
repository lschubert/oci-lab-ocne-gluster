#!/bin/bash
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook setup.yml
# make sure HEKETI_ADMIN_PASS and HEKETI_USER_PASS are set
if [[ ! -v HEKETI_ADMIN_PASS ]];
then
  echo "HEKETI_ADMIN_PASS variable must be set!"
  exit 1
fi
if [[ ! -v HEKETI_USER_PASS ]];
then
  echo "HEKETI_USER_PASS variable must be set!"
  exit 1
fi
ansible-playbook -e "HEKETI_ADMIN_PASS=${HEKETI_ADMIN_PASS} HEKETI_USER_PASS=${HEKETI_USER_PASS}" -i ./hosts setup.yml