resource "oci_core_public_ip" "reserved_public_ip_assigned" {
  compartment_id = var.compartment_ocid
  display_name   = "ReservedPublicIP"
  lifetime       = "RESERVED"
}

##Public LoadBalancer for Moodle Webservers

resource "oci_load_balancer" "public_loadbalancer" {
	shape          	= "10Mbps"
	compartment_id 	= var.compartment_ocid
	is_private 		= false
	reserved_ips {
        id = oci_core_public_ip.reserved_public_ip_assigned.id
    }
	subnet_ids 		= [
		oci_core_subnet.vcn_moodle_public_subnet.id,
	]
	display_name 	= "PublicLoadBalancer"
}

resource "oci_load_balancer_backend_set" "lb_backendset" {
	name             	= "lb_backendset"
	load_balancer_id 	= oci_load_balancer.public_loadbalancer.id
	policy           	= "ROUND_ROBIN"
  
	health_checker {
		port                	= "80"
		protocol            	= "TCP"
		interval_ms         	= "10000"
		timeout_in_millis   	= "3000"
		retries             	= "3"
		}
	
}

resource "oci_load_balancer_listener" "lb_listener" {
	load_balancer_id         	= oci_load_balancer.public_loadbalancer.id
	name                     	= "lb_listener"
	default_backend_set_name 	= oci_load_balancer_backend_set.lb_backendset.name
	port                     	= 80
	protocol                 	= "HTTP"
}

resource "oci_load_balancer_backend" "lb_backend1" {
	load_balancer_id = oci_load_balancer.public_loadbalancer.id
	backendset_name  = oci_load_balancer_backend_set.lb_backendset.name
	ip_address       = oci_core_instance.moodle_main1.private_ip
	port             = 80
	backup           = false
	drain            = false
	offline          = false
	weight           = 1
}

resource "oci_load_balancer_backend" "lb_backend2" {
	load_balancer_id = oci_load_balancer.public_loadbalancer.id
	backendset_name  = oci_load_balancer_backend_set.lb_backendset.name
	ip_address       = oci_core_instance.moodle_main2.private_ip
	port             = 80
	backup           = false
	drain            = false
	offline          = false
	weight           = 1
}
