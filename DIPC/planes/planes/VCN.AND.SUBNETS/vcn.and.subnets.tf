###### 
###### Creación de VCN + Subnets + IGW
######
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.compartment_ocid}"
}

resource "oci_core_virtual_network" "sdunet" {
  cidr_block = "172.16.0.0/16"
  dns_label = "sdudns"
  compartment_id = "${var.compartment_ocid}"
  display_name = "sdunet"
}

resource "oci_core_subnet" "sdunet-ad1" {
  compartment_id = "${var.compartment_ocid}"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.0.name}"
  route_table_id      = "${oci_core_virtual_network.sdunet.default_route_table_id}"
  vcn_id              = "${oci_core_virtual_network.sdunet.id}"
  security_list_ids   = ["${oci_core_virtual_network.sdunet.default_security_list_id}"]
  dhcp_options_id     = "${oci_core_virtual_network.sdunet.default_dhcp_options_id}"

  display_name               = "sdunet-ad1"
  cidr_block                 = "172.16.1.0/24"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "sdunet-ad2" {
  compartment_id = "${var.compartment_ocid}"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.1.name}"
  route_table_id      = "${oci_core_virtual_network.sdunet.default_route_table_id}"
  vcn_id              = "${oci_core_virtual_network.sdunet.id}"
  security_list_ids   = ["${oci_core_virtual_network.sdunet.default_security_list_id}"]
  dhcp_options_id     = "${oci_core_virtual_network.sdunet.default_dhcp_options_id}"

  display_name               = "sdunet-ad2"
  cidr_block                 = "172.16.2.0/24"
  prohibit_public_ip_on_vnic = false
}

resource "oci_core_subnet" "sdunet-ad3" {
  compartment_id = "${var.compartment_ocid}"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.2.name}"
  route_table_id      = "${oci_core_virtual_network.sdunet.default_route_table_id}"
  vcn_id              = "${oci_core_virtual_network.sdunet.id}"
  security_list_ids   = ["${oci_core_virtual_network.sdunet.default_security_list_id}"]
  dhcp_options_id     = "${oci_core_virtual_network.sdunet.default_dhcp_options_id}"

  display_name               = "sdunet-ad3"
  cidr_block                 = "172.16.3.0/24"
  prohibit_public_ip_on_vnic = false
}

###
### Internet Gateway !!!
###

resource "oci_core_internet_gateway" "sduigw" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "sduigw"
    vcn_id = "${oci_core_virtual_network.sdunet.id}"
}

###
### Regla adicional en la route table !!!
###

resource "oci_core_route_table" "internetroutetable" {
    compartment_id = "${var.compartment_ocid}"
    display_name = "InternetRouteTable"
    route_rules {
        cidr_block = "0.0.0.0/0"
        network_entity_id = "${oci_core_internet_gateway.sduigw.id}"
    }
    vcn_id = "${oci_core_virtual_network.sdunet.id}"
}
