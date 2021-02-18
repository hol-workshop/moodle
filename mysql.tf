
data "oci_identity_availability_domains" "ads" {
	compartment_id = var.compartment_ocid
}
 
data "oci_identity_fault_domains" "test_fault_domains" {
    #Required
    availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
    compartment_id = var.compartment_ocid
}


resource oci_mysql_mysql_db_system MoodleDb {
  admin_password      	= var.mysql_admin_password
  admin_username      	= var.mysql_admin_user
  availability_domain 	= data.oci_identity_availability_domains.ads.availability_domains[0].name

  backup_policy {
    
    freeform_tags = {
    }
    is_enabled        = "false"
    retention_in_days = "7"
    window_start_time = "00:00"
  }
  compartment_id          = var.compartment_ocid
  configuration_id        = "ocid1.mysqlconfiguration.oc1..aaaaaaaalwzc2a22xqm56fwjwfymixnulmbq3v77p5v4lcbb6qhkftxf2trq"
  data_storage_size_in_gb = "100"
  display_name = "MoodleDBSystem"
  fault_domain = data.oci_identity_fault_domains.test_fault_domains.fault_domains[0].name
  freeform_tags = {
  }
  hostname_label = "moodle"
  port       = "3306"
  port_x     = "33060"
  shape_name = "MySQL.VM.Standard.E3.1.8GB"
  subnet_id = oci_core_subnet.vcn_moodle_private_subnet.id
}

output "MysqlDB_Private_IP" {
	value = oci_mysql_mysql_db_system.MoodleDb.ip_address 
}
