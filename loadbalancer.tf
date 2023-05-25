resource "oci_load_balancer_load_balancer" "LoadBalancer" {
  compartment_id = var.compartment_ocid
  display_name = "Web-LB"
  shape = "flexible"
  subnet_ids = [oci_core_subnet.LB_tier_subnet.id]
  shape_details {
    #Required
    maximum_bandwidth_in_mbps = var.load_balancer_max_band
    minimum_bandwidth_in_mbps = var.load_balancer_min_band
  }
  network_security_group_ids = [oci_core_network_security_group.LBSecurityGroup.id]
}

resource "oci_load_balancer_backend_set" "web_backend_set" {
  health_checker {
    #Required
    protocol = "HTTP"

    #Optional
    interval_ms = "10000"
    port = "80"
    response_body_regex = ""
    retries = "3"
    return_code = "200"
    timeout_in_millis = "3000"
    url_path = "/"
  }
  load_balancer_id = oci_load_balancer_load_balancer.LoadBalancer.id
  name = "web-servers-backend-set"
  policy = "ROUND_ROBIN"
}

resource "oci_load_balancer_backend" "web_server_01" {
  backendset_name = oci_load_balancer_backend_set.web_backend_set.name
  ip_address = oci_core_instance.WebServer1.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.LoadBalancer.id
  port = "80"
  backup = "false"
  drain = "false"
  offline = "false"
}

resource "oci_load_balancer_backend" "web_server_02" {
  backendset_name = oci_load_balancer_backend_set.web_backend_set.name
  ip_address = oci_core_instance.WebServer2.private_ip
  load_balancer_id = oci_load_balancer_load_balancer.LoadBalancer.id
  port = "80"
  backup = "false"
  drain = "false"
  offline = "false"
}

resource "oci_load_balancer_listener" "LB_Listener" {
  default_backend_set_name = oci_load_balancer_backend_set.web_backend_set.name
  load_balancer_id = oci_load_balancer_load_balancer.LoadBalancer.id
  name = "LB_Listener"
  port = "80"
  protocol = "HTTP"
}