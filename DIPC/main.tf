###### 
###### Creación de entorno completo:
######    - VCN + Subnet + IGW
######    - DB System
######    - Compute nodes
######    - Load Balancer
######
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "api_fingerprint" {}
variable "api_private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.api_fingerprint}"
  private_key_path = "${var.api_private_key_path}"
  region = "${var.region}"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.compartment_ocid}"
}

###
### Database system !!!
###

 resource "oci_database_db_system" "dipcDBSYSTEM11G" {
   availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.2.name}"
   compartment_id = "${var.compartment_ocid}"
   cpu_core_count = "1"
   database_edition = "ENTERPRISE_EDITION"
   db_home {
     database {
       "admin_password" = "ZZ0r_cle#1"
       "db_name" = "dipcDB"
     }
     db_version = "11.2.0.4"
     display_name = "dipcDB11g"
   }
   disk_redundancy = "NORMAL"
   shape = "VM.Standard2.1"
   subnet_id = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaagylbyo2hfbht7u72ghug6y234ijautvaepmm4vuum3y2yeysuf5q"
   ssh_public_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJIs2yN8yOE/by93733wHGob7L1l0Ly7xzsaxt+NTx8jDStIA4pRTizeYGzx59MsQv1E9rq/+04K4gNYal+GaLYcnFK67JRMG4+z56nmiNwcO0NJAn3sZsa9oARCmvKchO+wQf2bTFn++GvvetBWDqy3UKK8mk3cflBHJ8yJjgn4Ald2NcGw1gNqyLXgk6jZAtStS1epoyNgUWM7skh4v3JB1Q4rPWKQPiX16TNtdoGKT3rMntIk30p4k3TN60nCIEDhr5ZfOcIJLCoiiqqSRjcGers0zQpFlaaJU0TZ33UnTXPDW56dzLiZc5udvc8irk7TI+qz1eydzv/unbgHKb key"]
   display_name = "dipcDB11g"
   hostname = "dipcdb01"
   data_storage_size_in_gb = "256"
   license_model = "LICENSE_INCLUDED"
   node_count = "1"
 }



###
### APPCN01: compute Ubuntu con Tomcat: my.custom.ubuntu.16.04.v1.2.with.Tomcat !!!
###
data "oci_core_images" "OLImage" {
  # Oracle Linux 7.6 images
  compartment_id           = "${var.compartment_ocid}"
  shape                    = "VM.Standard1.2"
  operating_system         = "Oracle Linux"
  operating_system_version = "7.6"
}

resource "oci_core_instance" "dipcCompute01" {
  count = "1"

  compartment_id = "${var.compartment_ocid}"
  display_name   = "dipcCompute01"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.0.name}"

  shape = "VM.Standard2.1"

  source_details {
    source_type = "image"
    source_id   = "${lookup(data.oci_core_images.OLImage.images[0], "id")}"
  }

  create_vnic_details {
    subnet_id = "ocid1.subnet.oc1.eu-frankfurt-1.aaaaaaaauuvhycq6zprciqplxegnwybo2btutro4l4p4opqdpyh7n2wspiia"
    display_name = "eth0"
    assign_public_ip = true
    hostname_label = "dipcCompute01"
  }

  metadata {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJIs2yN8yOE/by93733wHGob7L1l0Ly7xzsaxt+NTx8jDStIA4pRTizeYGzx59MsQv1E9rq/+04K4gNYal+GaLYcnFK67JRMG4+z56nmiNwcO0NJAn3sZsa9oARCmvKchO+wQf2bTFn++GvvetBWDqy3UKK8mk3cflBHJ8yJjgn4Ald2NcGw1gNqyLXgk6jZAtStS1epoyNgUWM7skh4v3JB1Q4rPWKQPiX16TNtdoGKT3rMntIk30p4k3TN60nCIEDhr5ZfOcIJLCoiiqqSRjcGers0zQpFlaaJU0TZ33UnTXPDW56dzLiZc5udvc8irk7TI+qz1eydzv/unbgHKb key "
  }
}

