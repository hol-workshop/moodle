
resource "oci_core_volume" "moodlehtml" {
	availability_domain 	= data.oci_identity_availability_domains.ads.availability_domains[0].name
	compartment_id      	= var.compartment_ocid
	display_name        	= "moodlehtml"
	size_in_gbs         	= var.db_size
	is_auto_tune_enabled 	= true
}

resource "oci_core_volume_attachment" "moodlehtml_attach1" {
	attachment_type = "iscsi"
	instance_id     = oci_core_instance.moodle_main1.id
	volume_id       = oci_core_volume.moodlehtml.id
	device          =  "/dev/oracleoci/oraclevdb"
	is_read_only = false
	is_shareable = true
	use_chap = true
}

resource "oci_core_volume_attachment" "moodlehtml_attach2" {
	attachment_type = "iscsi"
	instance_id     = oci_core_instance.moodle_main2.id
	volume_id       = oci_core_volume.moodlehtml.id
	device          =  "/dev/oracleoci/oraclevdb"
	is_read_only = false
	is_shareable = true
	use_chap = true
}

resource "oci_core_volume" "moodledata" {
	availability_domain 	= data.oci_identity_availability_domains.ads.availability_domains[0].name
	compartment_id      	= var.compartment_ocid
	display_name        	= "moodledata"
	size_in_gbs         	= var.db_size
	is_auto_tune_enabled 	= true
}

resource "oci_core_volume_attachment" "moodledata_attach1" {
	attachment_type = "iscsi"
	instance_id     = oci_core_instance.moodle_main1.id
	volume_id       = oci_core_volume.moodledata.id
	device          =  "/dev/oracleoci/oraclevdc" 
	is_read_only = false
	is_shareable = true
	use_chap = true
}

resource "oci_core_volume_attachment" "moodledata_attach2" {
	attachment_type = "iscsi"
	instance_id     = oci_core_instance.moodle_main2.id
	volume_id       = oci_core_volume.moodledata.id
	device          =  "/dev/oracleoci/oraclevdc" 
	is_read_only = false
	is_shareable = true
	use_chap = true
}
