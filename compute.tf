data "oci_core_images" "OSImages" {
	compartment_id = var.compartment_ocid
	display_name   = var.instance_shape
}

resource "tls_private_key" "opc_key" {
	algorithm = "RSA"
	rsa_bits  = 4096
}

### BASTION HOST

resource "oci_core_instance" "bastion" {
	availability_domain 	= data.oci_identity_availability_domains.ads.availability_domains[2].name
	compartment_id 		= var.compartment_ocid
	display_name 			= "bastion_host"
	shape 				= var.instance_shape

	create_vnic_details {
		subnet_id = oci_core_subnet.vcn_moodle_public_subnet.id
		display_name = "bastion_vnic"
		assign_public_ip = true
	}

	source_details {
		source_type = "image"
		source_id   = var.instance_image_ocid[var.region]
		boot_volume_size_in_gbs = "50"
	}

	metadata = {
		ssh_authorized_keys = file("id_rsa.pub")
		user_data = data.template_cloudinit_config.bastion_cloud_init.rendered
	}
}


## MAIN APP SERVERS

resource "oci_core_instance" "moodle_main1" {
	availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
	fault_domain 		= data.oci_identity_fault_domains.test_fault_domains.fault_domains[0].name
	compartment_id 		= var.compartment_ocid
	display_name 		= var.instance_name1
	shape 				= var.instance_shape
 
	create_vnic_details {
		subnet_id 			= oci_core_subnet.vcn_moodle_private_subnet.id
		assign_public_ip	= false
	}
	source_details {
		source_type 			= "image"
		source_id   			= var.instance_image_ocid[var.region]
		boot_volume_size_in_gbs = "60"
	}
	metadata = {
		ssh_authorized_keys = file("id_rsa.pub")
  }
}

resource "oci_core_instance" "moodle_main2" {
	availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
	fault_domain 		= data.oci_identity_fault_domains.test_fault_domains.fault_domains[1].name
	compartment_id 		= var.compartment_ocid
	display_name 		= var.instance_name2
	shape 				= var.instance_shape
 
	create_vnic_details {
		subnet_id 			= oci_core_subnet.vcn_moodle_private_subnet.id
		assign_public_ip	= false
	}
	source_details {
		source_type 			= "image"
		source_id   			= var.instance_image_ocid[var.region]
		boot_volume_size_in_gbs = "60"
	}
	metadata = {
		ssh_authorized_keys = file("id_rsa.pub")
  }
}
