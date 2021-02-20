output "Bastion_IP_addresses" {
	value = oci_core_instance.bastion.public_ip
}

output "Moodle_Server1" {
	value = oci_core_instance.moodle_main1.private_ip
}

output "Moodle_Server2" {
	value = oci_core_instance.moodle_main2.private_ip
}

output "Moodle_LB_IP_address" {
	value = oci_load_balancer.public_loadbalancer.ip_address_details
}

