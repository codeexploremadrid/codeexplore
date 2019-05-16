locals {
  database_service_name  = "my-terraformed-database"
  database_backup_bucket = "${var.object_storage_bucket}"
  AD                     = 1
  availability_domain    = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[local.AD],"name")}"
}

resource "oraclepaas_database_service_instance" "database" {
  count             = 1
  name              = "${local.database_service_name}"
  description       = "Created by Terraform"
  version           = "12.2.0.1"
  edition           = "HP"
  subscription_type = "HOURLY"
  ssh_public_key    = "${join(" ",slice(split(" ",file("~/.ssh/id_rsa.pub")),0,2))}"

  bring_your_own_license = true

  # OCI Settings
  region              = "${var.region}"
  availability_domain = "${local.availability_domain}"
  subnet              = "${oci_core_subnet.subnet.id}"
  shape               = "VM.Standard2.1"

  database_configuration {
    admin_password     = "Pa55_Word"
    backup_destination = "BOTH"
    sid                = "ORCL"
    usable_storage     = 50
  }

  backups {
    cloud_storage_container = "https://swiftobjectstorage.${var.region}.oraclecloud.com/v1/${var.tenancy}/${local.database_backup_bucket}"
    cloud_storage_username  = "${var.object_storage_user}"
    cloud_storage_password  = "${var.swift_password}"
  }
}
