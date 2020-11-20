#!/bin/bash

gcp_create_accept_all_firewall_rules() {
  gcloud compute firewall-rules create test-vm --allow tcp,udp --source-ranges 0.0.0.0/0 --target-tags=in-accept-all-ports
}

gcp_create_nested_vm () {
  # https://cloud.google.com/compute/docs/instances/enable-nested-virtualization-vm-instances
  gcloud compute disks create test-disk --image-project ubuntu-os-cloud --image-family ubuntu-1804-lts --zone asia-southeast1-a \
    --licenses https://compute.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx
  gcloud compute images create nested-vm-image \
    --source-disk test-disk --source-disk-zone asia-southeast1-a \
    --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"
  gcloud compute disks delete test-disk
}

gcp_create_compute() {
  gcloud compute instances create test-compute \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image nested-vm-image \
    --machine-type e2-standard-8 `#8 vCPU, 16GB Mem` \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --tags in-accept-all-ports
}

gcp_remove_compute() {
  gcloud -q compute instances delete test-compute
}

