# Compute Instances
data "template_file" "user_data" {
  template = file("web-script.sh")
}

resource "oci_core_instance" "WebServer1" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD -1]["name"]
  compartment_id = var.compartment_ocid
  fault_domain = "FAULT-DOMAIN-1"
  display_name = "Web-Server-1"
  shape = var.instance_shape

  create_vnic_details {
    subnet_id = oci_core_subnet.Web_tier_subnet.id
    nsg_ids   = [oci_core_network_security_group.WebSecurityGroup.id, oci_core_network_security_group.SSHSecurityGroup.id]
    display_name = "Web-Server-1"
  }
  source_details {
    source_type = "image"
    source_id = lookup(data.oci_core_images.compute_images.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
    user_data = base64encode(data.template_file.user_data.rendered)
  }

}

resource "oci_core_instance" "WebServer2" {
  availability_domain = data.oci_identity_availability_domains.ADs.availability_domains[var.AD -1]["name"]
  compartment_id = var.compartment_ocid
  fault_domain = "FAULT-DOMAIN-2"
  display_name = "Web-Server-2"
  shape = var.instance_shape

  create_vnic_details {
    subnet_id = oci_core_subnet.Web_tier_subnet.id
    nsg_ids   = [oci_core_network_security_group.WebSecurityGroup.id, oci_core_network_security_group.SSHSecurityGroup.id]
    display_name = "Web-Server-2"
  }
  source_details {
    source_type = "image"
    source_id = lookup(data.oci_core_images.compute_images.images[0], "id")
    boot_volume_size_in_gbs = "50"
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
    user_data = base64encode(data.template_file.user_data.rendered)
  }

}