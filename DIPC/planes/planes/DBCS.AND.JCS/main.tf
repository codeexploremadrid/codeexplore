###### 
###### Creación de entorno completo:
######    - VCN + Subnet + IGW
######    - DB System
######    - JCS
######
variable "tenancy_ocid" {}
variable "tenancy" {}
variable "identity_domain" {}
variable "user_ocid" {}
variable "api_user" {}
variable "api_user_pwd" {}
variable "admin_user" {}
variable "admin_user_pwd" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "compartment_ocid" {}
variable "region" {}
variable "object_storage_user" {}
variable "swift_password" {}


locals { // Variables locales, modificar con valores ad'hoc !!! 
  database_service_name  = "skydbsystem"
  database_backup_bucket = "skydbbucket"
  database_listener_port = "1521"
  database_name = "skydb"
  database_pdb_name = "skypdb"
  database_version = "12.2.0.1"
  database_shape = "VM.Standard1.1"
  database_storage_gb = "50"
  database_edition = "EE_HP"
  database_sys_pwd = "AaZZ0r_cle#1"
  vcn_name = "skynet"
  vcn_cidr_block = "172.16.0.0/16"
  ad1_cidr_block = "172.16.1.0/24"
  ad2_cidr_block = "172.16.2.0/24"
  ad3_cidr_block = "172.16.3.0/24"
  internet_route_table_name = "internetroutetable"
  igw_name = "skyigw"
  jcs_service_name = "skyjcs"
  jcs_backup_bucket = "skyjcsbucket"
  jcs_edition = "EE"
  jcs_version = "12cRelease213"
  wls_shape = "VM.Standard1.1"
  wls_admin_user = "weblogic"
  wls_admin_pwd = "Weblogic_1"
}

provider "oci" {
  tenancy_ocid = "${var.tenancy_ocid}"
  user_ocid = "${var.user_ocid}"
  fingerprint = "${var.fingerprint}"
  private_key_path = "${var.private_key_path}"
  region = "${var.region}"
}

provider "oraclepaas" {
  identity_domain = "${var.identity_domain}"
  user = "${var.admin_user}"
  password = "${var.admin_user_pwd}"
//  database_endpoint = "https://dbaas.oraclecloud.com"
  database_endpoint = "https://psm.europe.oraclecloud.com"
//  java_endpoint = "https://jaas.oraclecloud.com"
  java_endpoint = "https://psm.europe.oraclecloud.com"
}

data "oci_identity_availability_domains" "ADs" {
  compartment_id = "${var.compartment_ocid}"
}

###
### Creacion de los buckets en Object Storage !!!
###
data "oci_objectstorage_namespace" "bucket1" {
}
data "oci_objectstorage_namespace" "bucket2" {
}
resource "oci_objectstorage_bucket" "bucket1" {
  compartment_id = "${var.compartment_ocid}"
  namespace = "${data.oci_objectstorage_namespace.bucket1.namespace}"
  name = "${local.database_backup_bucket}"
}

resource "oci_objectstorage_bucket" "bucket2" {
  compartment_id = "${var.compartment_ocid}"
  namespace = "${data.oci_objectstorage_namespace.bucket2.namespace}"
  name = "${local.jcs_backup_bucket}"
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


resource "oci_core_security_list" "ProductionSqlnetseclist" {
  compartment_id = "${var.compartment_ocid}"
  vcn_id = "${oci_core_virtual_network.ProductionVcn.id}"
  display_name = "SQLNET Security List for ${local.vcn_name}"

  // allow inbound tcp traffic from internet to port 1521
  ingress_security_rules 
  {
    protocol = "6" // tcp
    source = "${local.vcn_cidr_block}" // Solo desde las maquinas de Middleware
    stateless = false
 tcp_options 
     {
      // These values correspond to the destination port range.
      "min" = "${local.database_listener_port}"
      "max" = "${local.database_listener_port}"
     }
  }

}

resource "oci_core_subnet" "ProductionVcn-ad1" {
  compartment_id = "${var.compartment_ocid}"

  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.0.name}"
  route_table_id      = "${oci_core_route_table.InternetRouteTable.id}"
  vcn_id              = "${oci_core_virtual_network.ProductionVcn.id}"
  security_list_ids   = ["${oci_core_virtual_network.ProductionVcn.default_security_list_id}","${oci_core_security_list.ProductionSqlnetseclist.id}"]
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
  security_list_ids   = ["${oci_core_virtual_network.ProductionVcn.default_security_list_id}","${oci_core_security_list.ProductionSqlnetseclist.id}"]
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
  security_list_ids   = ["${oci_core_virtual_network.ProductionVcn.default_security_list_id}","${oci_core_security_list.ProductionSqlnetseclist.id}"]
  dhcp_options_id     = "${oci_core_virtual_network.ProductionVcn.default_dhcp_options_id}"
  dns_label = "DNSLABEL3"
  display_name               = "${local.vcn_name}-ad3"
  cidr_block                 = "${local.ad3_cidr_block}"
  prohibit_public_ip_on_vnic = false
}


###
### Database system !!!
###

 resource "oraclepaas_database_service_instance" "ProdDb" {

	name = "${local.database_service_name}"
	edition = "${local.database_edition}"
	level = "PAAS"
	shape = "${local.database_shape}"
	subscription_type = "HOURLY"
	version = "${local.database_version}"

	ssh_public_key = "${join(" ",slice(split(" ",file("/media/Data/Preventa/TMP/sshkeybundle/publicKey.pub")),0,2))}"

	database_configuration {
		admin_password     = "${local.database_sys_pwd}"
		backup_destination = "BOTH"
		sid                = "${local.database_name}"
		pdb_name           = "${local.database_pdb_name}"
		usable_storage     = "${local.database_storage_gb}"
	}

	backups {
                cloud_storage_container = "https://swiftobjectstorage.${var.region}.oraclecloud.com/v1/${var.tenancy}/${local.database_backup_bucket}"
                cloud_storage_username  = "${var.object_storage_user}"
                cloud_storage_password  = "${var.swift_password}"
	}

	description = "Sistema de base de datos PaaS provisionado por Terraform"
	region = "${var.region}"
        availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.1.name}"
	subnet = "${oci_core_subnet.ProductionVcn-ad2.id}"

        timeouts {
           create = "120m"
        }
  }
		

resource "oraclepaas_java_service_instance" "ProductionJcs" {

  name        = "${local.jcs_service_name}"
  description = "Created by Terraform"

  edition                = "${local.jcs_edition}"            // SE EE SUITE
  service_version        = "${local.jcs_version}" // 12cRelease213, 12cRelease212 12cR3, 11gR1
  metering_frequency     = "HOURLY"        // HOURLY MONTHLY

  ssh_public_key = "${join(" ",slice(split(" ",file("/media/Data/Preventa/TMP/sshkeybundle/publicKey.pub")),0,2))}"

  # OCI Settings
  region              = "${var.region}"
  availability_domain = "${data.oci_identity_availability_domains.ADs.availability_domains.1.name}"
  subnet              = "${oci_core_subnet.ProductionVcn-ad2.id}"

  weblogic_server {
    shape = "${local.wls_shape}"

    database {
      name     = "${oraclepaas_database_service_instance.ProdDb.name}"
      username = "sys"
      password = "${local.database_sys_pwd}"
    }

    admin {
      username = "${local.wls_admin_user}"
      password = "${local.wls_admin_pwd}"
    }
  }

  backups {
    cloud_storage_container = "https://swiftobjectstorage.${var.region}.oraclecloud.com/v1/${var.tenancy}/${local.jcs_backup_bucket}"
    cloud_storage_username  = "${var.object_storage_user}"
    cloud_storage_password  = "${var.swift_password}"
  }
}


