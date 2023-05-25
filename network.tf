# VCN
resource "oci_core_vcn" "vcn" {
  compartment_id = var.compartment_ocid
  cidr_block = var.vcn_cidr
  dns_label = var.vcn_dns_label
  display_name = var.vcn_dns_label
}

# Internet Gateway
resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_ocid
  display_name = "${var.vcn_dns_label}igw"
  vcn_id = oci_core_vcn.vcn.id
}

# NAT Gateway
resource "oci_core_nat_gateway" "nat_gw" {
  compartment_id = var.compartment_ocid
  display_name   = "${var.vcn_dns_label}nat_gateway"
  vcn_id         = oci_core_vcn.vcn.id
}

# Public Route Table
resource "oci_core_route_table" "PublicRT" {
  compartment_id = var.compartment_ocid
  display_name = "${var.vcn_dns_label}pubrt"
  vcn_id = oci_core_vcn.vcn.id

  route_rules {
    destination = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.igw.id
  }
}

# Private Route table
resource "oci_core_route_table" "PrivateRT" {
  compartment_id = var.compartment_ocid
  vcn_id         = oci_core_vcn.vcn.id
  display_name   = "${var.vcn_dns_label}privrt"
  route_rules {
    destination       = "0.0.0.0/0"
    network_entity_id = oci_core_nat_gateway.nat_gw.id
  }
}

# Subnets
resource "oci_core_subnet" "LB_tier_subnet" {
  availability_domain = ""
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id
  cidr_block = cidrsubnet(var.vcn_cidr,8,1)
  display_name = "public${var.dns_label}1"
  dns_label = "public${var.dns_label}1"
  route_table_id = oci_core_route_table.PublicRT.id
  #security_list_ids = [oci_core_security_list.securitylist01.id]
}

resource "oci_core_subnet" "Web_tier_subnet" {
  availability_domain = ""
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id
  cidr_block = cidrsubnet(var.vcn_cidr,8,2)
  display_name = "public${var.dns_label}2"
  dns_label = "public${var.dns_label}2"
  route_table_id = oci_core_route_table.PublicRT.id
  #security_list_ids = [oci_core_security_list.securitylist02.id]
}

resource "oci_core_subnet" "DB_tier_subnet" {
  availability_domain = ""
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id
  cidr_block = cidrsubnet(var.vcn_cidr,8,3)
  display_name = "private${var.dns_label}1"
  dns_label = "private${var.dns_label}1"
  route_table_id = oci_core_route_table.PrivateRT.id
}

/*
resource "oci_core_security_list" "securitylist01" {
  display_name = "SL_public01"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id

  egress_security_rules{
    protocol = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"

    tcp_options {
        min = 80
        max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"

    tcp_options {
        min = 22
        max = 22
    }
  }
}

resource "oci_core_security_list" "securitylist02" {
  display_name = "SL_public02"
  compartment_id = var.compartment_ocid
  vcn_id = oci_core_vcn.vcn.id

  egress_security_rules{
    protocol = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source = oci_core_subnet.LB_tier_subnet.cidr_block

    tcp_options {
        min = 80
        max = 80
    }
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"

    tcp_options {
        min = 22
        max = 22
    }
  }
}
*/