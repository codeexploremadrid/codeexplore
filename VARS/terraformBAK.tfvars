# Copyright 2017, 2019, Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

# Identity and access parameters

api_fingerprint = "77:36:b2:3b:6e:3b:45:0e:fa:e7:9c:ea:3d:0e:50:f0"

api_private_key_path = "../KEYS/ocikey"

compartment_name = "codeexplore"

compartment_ocid = "ocid1.compartment.oc1..aaaaaaaa7tbvlkrfgwd56t5uqh3bw3j5wm65kq4kyewjp7q4wd6jxexdwgjq"

tenancy_ocid = "ocid1.tenancy.oc1..aaaaaaaacm3tqgzzg76vqknh5ozkybsayvjdxhzmuuh2ykl5suo2npdnxyfq"

user_ocid = "ocid1.user.oc1..aaaaaaaakcrueowom73wl2hftslytu5ovn6ns2cukxynglga2ueovjlhqg4q"

# ssh keys

ssh_private_key_path = "../KEYS/ocikey"

ssh_public_key_path = "../KEYS/ocikey.pub"

# general oci parameters
label_prefix = "oke"

region = "eu-frankfurt-1"

# networking

newbits = {
  "bastion" = "8"
  "lb"      = "8"
  "workers" = "8"
}

subnets = {
  "bastion"     = "11"
  "lb_ad1"      = "12"
  "lb_ad2"      = "22"
  "lb_ad3"      = "32"
  "workers_ad1" = "13"
  "workers_ad2" = "23"
  "workers_ad3" = "33"
}

vcn_cidr = "10.0.0.0/16"

vcn_dns_name = "oke"

vcn_name = "oke vcn"

create_nat_gateway = "true"

nat_gateway_name = "nat"

create_service_gateway = "true"

service_gateway_name = "sg"

# bastion

bastion_shape = "VM.Standard2.1"

create_bastion = "true"

enable_instance_principal = "false"

image_operating_system = "Oracle Linux"

image_operating_system_version = "7.6"

# availability_domains

availability_domains = {
  "bastion"     = "1"
  "lb_ad1"      = "1"
  "lb_ad2"      = "2"
  "lb_ad3"      = "3"
  "workers_ad1" = "1"
  "workers_ad2" = "2"
  "workers_ad3" = "3"
}

# oke

cluster_name = "oke"

worker_mode = "private"

dashboard_enabled = "true"

kubernetes_version = "LATEST"

node_pools = "1"

node_pool_name_prefix = "np"

node_pool_node_image_name = "Oracle-Linux-7.6"

node_pool_node_shape = "VM.Standard2.1"

node_pool_quantity_per_subnet = "1"

nodepool_topology = "3"

pods_cidr = "10.244.0.0/16"

services_cidr = "10.96.0.0/16"

tiller_enabled = "true"

# ocir
create_auth_token = "true"

email_address = "guillermo.best@oracle.com"

tenancy_name = "enimbos"

username = "guillermo"

# helm

helm_version = "2.12.3"

install_helm = "true"

# calico

calico_version = "3.6"

install_calico = "false"
