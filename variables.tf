# Data from terraform.tfvars file

variable "tenancy_ocid" {}
variable "ssh_public_key" {}
variable "compartment_ocid" {}

variable "region" {
  default = "eu-amsterdam-1"
}

# Availability Domain

variable "AD" {
  default = "1"
}

# VCN Variables

variable "vcn_cidr" {
  default = "10.0.0.0/16"
}

variable "vcn_dns_label" {
  description = "VCN DNS label"
  default = "vcn"
}

variable "dns_label" {
  description = "Subnet DNS label"
  default = "subnet"
}

# OS Image

variable "image_operating_system" {
  default = "Oracle Linux"
}
variable "image_operating_system_version" {
  default = "8"
}

# Compute Shape

variable "instance_shape" {
  description = "Instance Shape"
  default = "VM.Standard.E2.1.Micro"
}

# Load Balancer Shape

variable "load_balancer_min_band" {
  description = "Load Balancer Min Band"
  default = "10"
}

variable "load_balancer_max_band" {
  description = "Load Balancer Max Band"
  default = "10"
}


# database vars
variable "ATP_database_db_name" {
  default = "aTFdb"
}

variable "ATP_password" {}

variable "ATP_database_db_version" {
  default = "19c"
}

variable "ATP_database_defined_tags_value" {
  default = "value"
}

variable "ATP_database_display_name" {
  default = "ATP"
}

variable "ATP_database_cpu_core_count" {
  default = 1
}

variable "ATP_database_data_storage_size_in_tbs" {
  default = 1
}

variable "ATP_database_license_model" {
  default = "LICENSE_INCLUDED"
}

variable "ATP_tde_wallet_zip_file" {
  default = "tde_wallet_aTFdb.zip"
}

variable "ATP_private_endpoint" {
  default = true
}

variable "ATP_private_endpoint_label" {
  default = "ATPPrivateEndpoint"
}

variable "ATP_data_guard_enabled" {
  default = false
}
