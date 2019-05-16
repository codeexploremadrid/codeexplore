###### 
###### Creaci�n de entorno completo:
######    - VCN + Subnet + IGW
######
variable "tenancy_ocid" {}
variable "tenancy_name" {}
variable "user_ocid" {}
variable "api_fingerprint" {}
variable "api_private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}


locals { // Variables locales, modificar con valores ad'hoc !!! 
  vcn_name = "skynet"
  vcn_cidr_block = "172.16.0.0/16"
  ad1_cidr_block = "172.16.1.0/24"
  ad2_cidr_block = "172.16.2.0/24"
  ad3_cidr_block = "172.16.3.0/24"
  internet_route_table_name = "internetroutetable"
  igw_name = "skyigw"
}

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
### Creacion VCN !!!
###

resource "oci_core_virtual_network" "ProductionVcn" {
  cidr_block = "${local.vcn_cidr_block}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "${local.vcn_name}"
  dns_label = "${local.vcn_name}"
}


###
### Internet Gateway !!!
###

resource "oci_core_internet_gateway" "ProductionIgw" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${local.igw_name}"
    vcn_id = "${oci_core_virtual_network.ProductionVcn.id}"
}


###
### Nueva Route table !!!
###

resource "oci_core_route_table" "InternetRouteTable" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "${local.internet_route_table_name}"
    route_rules {
        destination = "0.0.0.0/0"
        network_entity_id = "${oci_core_internet_gateway.ProductionIgw.id}"
    }
    vcn_id = "${oci_core_virtual_network.ProductionVcn.id}"
}


##
## Agregar una security list a la que viene por defecto
##    En esta vamos a agregar reglas de entrada a los puertos 80 y 8080 !!!
##    
##

resource "oci_core_security_list" "ProductionAdhocseclist" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.ProductionVcn.id}"
  display_name = "Adhoc Security List for ${local.vcn_name}"

  // allow inbound tcp traffic from internet to port 80
  ingress_security_rules 
  {
    protocol = "6" // tcp
    source = "0.0.0.0/0"
    stateless = false
 tcp_options 
     {
      // These values correspond to the destination port range.
      "min" = 80
      "max" = 80
     }
  }

  // allow inbound tcp traffic from VCN to port 1521
  ingress_security_rules 
  {
    protocol = "6" // tcp
    source = "0.0.0.0/0"
    stateless = false
 tcp_options 
     {
      // These values correspond to the destination port range.
      "min" = 1521
      "max" = 1521
     }
  }

  // allow inbound tcp traffic from internet to port 8080
  ingress_security_rules 
  {
    protocol = "6" // tcp
    source = "0.0.0.0/0"
    stateless = false
 tcp_options 
     {
      // These values correspond to the destination port range.
      "min" = 8080
      "max" = 8080
     }
  }
}


resource "oci_core_subnet" "ProductionVcn-ad1" {
  compartment_id = "${var.compartment_ocid}"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.0.name}"
  route_table_id      = "${oci_core_route_table.InternetRouteTable.id}"
  vcn_id              = "${oci_core_virtual_network.ProductionVcn.id}"
  security_list_ids   = ["${oci_core_virtual_network.ProductionVcn.default_security_list_id}","${oci_core_security_list.ProductionAdhocseclist.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.ProductionVcn.default_dhcp_options_id}"
  dns_label = "DNSLABEL1"
  display_name               = "${local.vcn_name}-ad1"
  cidr_block                 = "${local.ad1_cidr_block}"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "ProductionVcn-ad2" {
  compartment_id = "${var.compartment_ocid}"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.1.name}"
  route_table_id      = "${oci_core_route_table.InternetRouteTable.id}"
  vcn_id              = "${oci_core_virtual_network.ProductionVcn.id}"
  security_list_ids   = ["${oci_core_virtual_network.ProductionVcn.default_security_list_id}","${oci_core_security_list.ProductionAdhocseclist.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.ProductionVcn.default_dhcp_options_id}"
  dns_label = "DNSLABEL2"
  display_name               = "${local.vcn_name}-ad2"
  cidr_block                 = "${local.ad2_cidr_block}"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "ProductionVcn-ad3" {
  compartment_id = "${var.compartment_ocid}"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.2.name}"
//  route_table_id      = "${oci_core_route_table.InternetRouteTable.id}"
  route_table_id      = "${oci_core_route_table.InternetRouteTable.id}"
  vcn_id              = "${oci_core_virtual_network.ProductionVcn.id}"
  security_list_ids   = ["${oci_core_virtual_network.ProductionVcn.default_security_list_id}","${oci_core_security_list.ProductionAdhocseclist.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.ProductionVcn.default_dhcp_options_id}"
  dns_label = "DNSLABEL3"
  display_name               = "${local.vcn_name}-ad3"
  cidr_block                 = "${local.ad3_cidr_block}"
  prohibit_public_ip_on_vnic = false
}


###
### Database system !!!
###

 resource "oci_database_db_system" "DBCODEEXPL" {
   availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.0.name}"
   compartment_id = "${var.compartment_ocid}"
   cpu_core_count = "2"
   database_edition = "ENTERPRISE_EDITION_EXTREME_PERFORMANCE"
   db_home {
     database {
       "admin_password" = "ZZ0r_cle#1"
       "db_name" = "CEDB"
       "pdb_name" = "CEPDB"
     }
     db_version = "18.4.0.0"
     display_name = "CODEEPLOREDB"
   }
   disk_redundancy = "NORMAL"
   shape = "VM.Standard2.1"
   subnet_id = "${oci_core_subnet.ProductionVcn-ad1.id}"
   ssh_public_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDdSYVIvv/pCTVX0UE/R+KmnuzI3wIGP23XZPCRQp+q71dTbbCCM/wEEXJ4idSLZpRGF0vKXWi9G2yShnFIL0TYLXEwptxc0csNkG8sl4FStAGIiSGzCXoIDMjYc3dF8Gq2M3Rlaf7o1snUmlH3rQIgvAhWfwxFBj+iFDb6+R1keMG6pzK420QRFpXYUmZhWBQeE3lFsusArao9ByIH3fw/juMsFmU3WHtgu2VtDI81gprk24Si380yyVzSms2V2ipIHihE2jhz/GvJ4FNdbjn9/t+OmApMigHmjvFq05fsrh75P+7FRbCIWB5KUA+Gq11LcZchh29TKl1oSGzcSu7B"]
   display_name = "CODEEPLOREDB"
   hostname = "dbcn01"
   data_storage_size_in_gb = "256"
   license_model = "BRING_YOUR_OWN_LICENSE"
   node_count = "1"
 }

 resource "oci_database_db_system" "dipcDBSYSTEM11G" {
   availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.0.name}"
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
   subnet_id = "${oci_core_subnet.ProductionVcn-ad1.id}"
   ssh_public_keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDJIs2yN8yOE/by93733wHGob7L1l0Ly7xzsaxt+NTx8jDStIA4pRTizeYGzx59MsQv1E9rq/+04K4gNYal+GaLYcnFK67JRMG4+z56nmiNwcO0NJAn3sZsa9oARCmvKchO+wQf2bTFn++GvvetBWDqy3UKK8mk3cflBHJ8yJjgn4Ald2NcGw1gNqyLXgk6jZAtStS1epoyNgUWM7skh4v3JB1Q4rPWKQPiX16TNtdoGKT3rMntIk30p4k3TN60nCIEDhr5ZfOcIJLCoiiqqSRjcGers0zQpFlaaJU0TZ33UnTXPDW56dzLiZc5udvc8irk7TI+qz1eydzv/unbgHKb key"]
   display_name = "dipcDB11g"
   hostname = "dipcdb01"
   data_storage_size_in_gb = "256"
   license_model = "LICENSE_INCLUDED"
   node_count = "1"
 }