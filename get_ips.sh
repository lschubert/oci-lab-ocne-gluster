export LC_ALL=C.UTF-8
export LANG=C.UTF-8
oci compute instance list-vnics --compartment-id ${OCI_COMPARTMENT_OCID} | jq -r '.[][] | ."hostname-label" + ": " + ."public-ip"' | sort | sed "s/-control01/_control_ip/" | sed "s/-operator/_operator_ip/" | sed "s/-worker01:/_worker_ip:\n  -/" | sed "s/ocne-worker02:/  -/" | sed "s/ocne-worker03:/  -/"