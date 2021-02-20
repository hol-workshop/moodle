resource "oci_core_vcn" "vcn_moodle" {
  cidr_block     = var.vcn_moodle_cidr_block
  dns_label      = var.vcn_moodle_dns_label
  compartment_id = var.compartment_ocid
  display_name   = var.vcn_moodle_display_name
}

#IGW
resource "oci_core_internet_gateway" "vcn_moodle_igw" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn_moodle.id
    enabled = "true"
    display_name = "vcn_moodle_igw"
}


#Public RT
resource "oci_core_route_table" "vcn_moodle_public_route_table" {
    compartment_id = var.compartment_ocid
	display_name = "vcn_moodle_public_route_table"
    vcn_id = oci_core_vcn.vcn_moodle.id
    route_rules {
        network_entity_id = oci_core_internet_gateway.vcn_moodle_igw.id
        cidr_block = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

#Public SL
resource "oci_core_security_list" "vcn_moodle_public_security_list" {
    display_name   = "vcn_moodle_public_security_list"
	compartment_id = var.compartment_ocid
	vcn_id         = oci_core_vcn.vcn_moodle.id
	
    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol = "all"
    }
	egress_security_rules {
        destination      = var.vcn_moodle_private_subnet_cidr_block
        destination_type = "CIDR_BLOCK"
        protocol         = "6"

        tcp_options {
            max = 80
            min = 80
            }
	}
    ingress_security_rules {
        source = "0.0.0.0/0"
        protocol = "all"
    }      
}

#NAT
resource "oci_core_nat_gateway" "vcn_moodle_nat_gateway" {
    compartment_id = var.compartment_ocid
    vcn_id = oci_core_vcn.vcn_moodle.id
    display_name = "vcn_moodle_nat_gateway"
}

#Private RT
resource "oci_core_route_table" "vcn_moodle_private_route_table" {
    compartment_id = var.compartment_ocid
	display_name = "vcn_moodle_private_route_table"
    vcn_id = oci_core_vcn.vcn_moodle.id
    route_rules {
        network_entity_id = oci_core_nat_gateway.vcn_moodle_nat_gateway.id
        cidr_block = "0.0.0.0/0"
        destination_type = "CIDR_BLOCK"
    }
}

#Private SL
resource "oci_core_security_list" "vcn_moodle_private_security_list" {
    display_name   = "vcn_moodle_private_security_list"
    compartment_id = var.compartment_ocid
	vcn_id         = oci_core_vcn.vcn_moodle.id
    egress_security_rules {
        destination = "0.0.0.0/0"
        protocol = "all"
    }
	ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_moodle_public_subnet_cidr_block
        source_type = "CIDR_BLOCK"
        tcp_options {
            max = 80
            min = 80
        }
	}
	ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_moodle_cidr_block
        source_type = "CIDR_BLOCK"
        tcp_options {
            max = 3306
            min = 3306
        }
	}
	ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_moodle_cidr_block
        source_type = "CIDR_BLOCK"
        tcp_options {
            max = 22
            min = 22
        }
	}
	ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_moodle_cidr_block
        source_type = "CIDR_BLOCK"
        tcp_options {
            max = 33060
            min = 33060
        }
	}
	ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_moodle_cidr_block
        source_type = "CIDR_BLOCK"
        tcp_options {
            max = 7777
            min = 7777
        }
	}
	ingress_security_rules {
        protocol    = "6"
        source      = var.vcn_moodle_cidr_block
        source_type = "CIDR_BLOCK"
        tcp_options {
            max = 3260
            min = 3260
        }
	}
		ingress_security_rules {
        protocol    = "all"
        source      = var.vcn_moodle_cidr_block
        source_type = "CIDR_BLOCK"
	}
}

#PUBLIC SUBNET
resource "oci_core_subnet" "vcn_moodle_public_subnet" {
    cidr_block = var.vcn_moodle_public_subnet_cidr_block
    compartment_id = var.compartment_ocid
    dns_label = "moodlepublic"
    vcn_id = oci_core_vcn.vcn_moodle.id
    display_name = var.vcn_moodle_public_subnet_display_name
	security_list_ids   = [oci_core_security_list.vcn_moodle_public_security_list.id]
}

resource "oci_core_route_table_attachment" "vcn_moodle_public_subnet_route_table_attachment" {
  subnet_id = oci_core_subnet.vcn_moodle_public_subnet.id
  route_table_id = oci_core_route_table.vcn_moodle_public_route_table.id
}


#PRIVATE SUBNET
resource "oci_core_subnet" "vcn_moodle_private_subnet" {
    cidr_block = var.vcn_moodle_private_subnet_cidr_block
    compartment_id = var.compartment_ocid
	dns_label = "moodleprivate"
    vcn_id = oci_core_vcn.vcn_moodle.id
    display_name = var.vcn_moodle_private_subnet_display_name
	security_list_ids   = [oci_core_security_list.vcn_moodle_private_security_list.id]
}

resource "oci_core_route_table_attachment" "vcn_moodle_private_subnet_route_table_attachment" {
   subnet_id = oci_core_subnet.vcn_moodle_private_subnet.id
   route_table_id = oci_core_route_table.vcn_moodle_private_route_table.id
 }
