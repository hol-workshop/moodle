data "template_file" "moodle_script1" {
  template = file("moodle1_cloud_init.sh")
  vars = {
    "ssh_public_key" 	= file("id_rsa.pub")
	"ssh_private_key" 	= file("id_rsa")
	"node1"					= oci_core_instance.moodle_main1.private_ip
	"node2"					= oci_core_instance.moodle_main2.private_ip
  }
}

resource "null_resource" "moodle1_cloud_init" {
	depends_on = [oci_core_instance.bastion,oci_core_volume_attachment.moodlehtml_attach1,oci_core_volume_attachment.moodledata_attach1]

	provisioner "file" {
    connection {
		type        = "ssh"
		user        = "opc"
		host        = oci_core_instance.moodle_main1.private_ip
		private_key = file("id_rsa")
		script_path = "/home/opc/moodle1.sh"
		agent       = false
		timeout     = "12m"
		bastion_host = oci_core_instance.bastion.public_ip
		bastion_port = "22"
		bastion_user = "opc"
		bastion_private_key = file("id_rsa")
    }
	content     = data.template_file.moodle_script1.rendered
		destination = "/home/opc/moodle1_cloud_init.sh"
	}
	provisioner "remote-exec" {
    connection {
		type        = "ssh"
		user        = "opc"
		host        = oci_core_instance.moodle_main1.private_ip
		private_key = file("id_rsa")
		script_path = "/home/opc/moodle1.sh"
		agent       = false
		timeout     = "12m"
		bastion_host = oci_core_instance.bastion.public_ip
		bastion_port = "22"
		bastion_user = "opc"
		bastion_private_key = file("id_rsa")
  
    }
    inline = [
		"sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.moodlehtml_attach1.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach1.ipv4}:${oci_core_volume_attachment.moodlehtml_attach1.port}",
		"sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.moodlehtml_attach1.iqn} -n node.startup -v automatic",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach1.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach1.ipv4}:${oci_core_volume_attachment.moodlehtml_attach1.port} -o update -n node.session.auth.authmethod -v CHAP",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach1.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach1.ipv4}:${oci_core_volume_attachment.moodlehtml_attach1.port} -o update -n node.session.auth.username -v ${oci_core_volume_attachment.moodlehtml_attach1.chap_username}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach1.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach1.ipv4}:${oci_core_volume_attachment.moodlehtml_attach1.port} -o update -n node.session.auth.password -v ${oci_core_volume_attachment.moodlehtml_attach1.chap_secret}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach1.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach1.ipv4}:${oci_core_volume_attachment.moodlehtml_attach1.port} -l",
		"sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.moodledata_attach1.iqn} -p ${oci_core_volume_attachment.moodledata_attach1.ipv4}:${oci_core_volume_attachment.moodledata_attach1.port}",
		"sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.moodledata_attach1.iqn} -n node.startup -v automatic",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach1.iqn} -p ${oci_core_volume_attachment.moodledata_attach1.ipv4}:${oci_core_volume_attachment.moodledata_attach1.port} -o update -n node.session.auth.authmethod -v CHAP",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach1.iqn} -p ${oci_core_volume_attachment.moodledata_attach1.ipv4}:${oci_core_volume_attachment.moodledata_attach1.port} -o update -n node.session.auth.username -v ${oci_core_volume_attachment.moodledata_attach1.chap_username}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach1.iqn} -p ${oci_core_volume_attachment.moodledata_attach1.ipv4}:${oci_core_volume_attachment.moodledata_attach1.port} -o update -n node.session.auth.password -v ${oci_core_volume_attachment.moodledata_attach1.chap_secret}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach1.iqn} -p ${oci_core_volume_attachment.moodledata_attach1.ipv4}:${oci_core_volume_attachment.moodledata_attach1.port} -l",
		"chmod +x ~/moodle1_cloud_init.sh",
		"sudo ~/moodle1_cloud_init.sh"
    ]
  }
}



data "template_file" "bastion_script" {
  template = file("bastion.tpl")
  vars = {
    "ssh_public_key" 	= file("id_rsa.pub")
	"ssh_private_key" 	= file("id_rsa")
	"mysql_admin_user" 	= "${var.mysql_admin_user}"
	"mysql_admin_password" 	= "${var.mysql_admin_password}"
	"mysql_host" 			= "${oci_mysql_mysql_db_system.MoodleDb.ip_address}"
  }
}

data "template_cloudinit_config" "bastion_cloud_init" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "cloud-init.sh"
    content_type = "text/x-shellscript"
    content      = data.template_file.bastion_script.rendered
  }

}

data "template_file" "moodle_script2" {
  template = file("moodle2_cloud_init.sh")
  vars = {
    "ssh_public_key" 	= file("id_rsa.pub")
	"ssh_private_key" 	= file("id_rsa")
	"node1"					= oci_core_instance.moodle_main1.private_ip
	"node2"					= oci_core_instance.moodle_main2.private_ip
  }
}

resource "null_resource" "moodle2_cloud_init" {
	depends_on = [oci_core_instance.bastion,oci_core_volume_attachment.moodlehtml_attach2,oci_core_volume_attachment.moodledata_attach2]
	provisioner "file" {
    connection {
		type        = "ssh"
		user        = "opc"
		host        = oci_core_instance.moodle_main2.private_ip
		private_key = file("id_rsa")
		script_path = "/home/opc/moodle2.sh"
		agent       = false
		timeout     = "12m"
		bastion_host = oci_core_instance.bastion.public_ip
		bastion_port = "22"
		bastion_user = "opc"
		bastion_private_key = file("id_rsa")
    }
	content     = data.template_file.moodle_script2.rendered
		destination = "/home/opc/moodle2_cloud_init.sh"
	}
	provisioner "remote-exec" {
    connection {
		type        = "ssh"
		user        = "opc"
		host        = oci_core_instance.moodle_main2.private_ip
		private_key = file("id_rsa")
		script_path = "/home/opc/moodle2.sh"
		agent       = false
		timeout     = "12m"
		bastion_host = oci_core_instance.bastion.public_ip
		bastion_port = "22"
		bastion_user = "opc"
		bastion_private_key = file("id_rsa")
  
    }
    inline = [
		"sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.moodledata_attach2.iqn} -p ${oci_core_volume_attachment.moodledata_attach2.ipv4}:${oci_core_volume_attachment.moodledata_attach2.port}",
		"sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.moodledata_attach2.iqn} -n node.startup -v automatic",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach2.iqn} -p ${oci_core_volume_attachment.moodledata_attach2.ipv4}:${oci_core_volume_attachment.moodledata_attach2.port} -o update -n node.session.auth.authmethod -v CHAP",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach2.iqn} -p ${oci_core_volume_attachment.moodledata_attach2.ipv4}:${oci_core_volume_attachment.moodledata_attach2.port} -o update -n node.session.auth.username -v ${oci_core_volume_attachment.moodledata_attach2.chap_username}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach2.iqn} -p ${oci_core_volume_attachment.moodledata_attach2.ipv4}:${oci_core_volume_attachment.moodledata_attach2.port} -o update -n node.session.auth.password -v ${oci_core_volume_attachment.moodledata_attach2.chap_secret}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodledata_attach2.iqn} -p ${oci_core_volume_attachment.moodledata_attach2.ipv4}:${oci_core_volume_attachment.moodledata_attach2.port} -l",
		"sudo iscsiadm -m node -o new -T ${oci_core_volume_attachment.moodlehtml_attach2.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach2.ipv4}:${oci_core_volume_attachment.moodlehtml_attach2.port}",
		"sudo iscsiadm -m node -o update -T ${oci_core_volume_attachment.moodlehtml_attach2.iqn} -n node.startup -v automatic",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach2.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach2.ipv4}:${oci_core_volume_attachment.moodlehtml_attach2.port} -o update -n node.session.auth.authmethod -v CHAP",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach2.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach2.ipv4}:${oci_core_volume_attachment.moodlehtml_attach2.port} -o update -n node.session.auth.username -v ${oci_core_volume_attachment.moodlehtml_attach2.chap_username}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach2.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach2.ipv4}:${oci_core_volume_attachment.moodlehtml_attach2.port} -o update -n node.session.auth.password -v ${oci_core_volume_attachment.moodlehtml_attach2.chap_secret}",
		"sudo iscsiadm -m node -T ${oci_core_volume_attachment.moodlehtml_attach2.iqn} -p ${oci_core_volume_attachment.moodlehtml_attach2.ipv4}:${oci_core_volume_attachment.moodlehtml_attach2.port} -l",
		"chmod +x ~/moodle2_cloud_init.sh",
		"sudo ~/moodle2_cloud_init.sh"
    ]
  }
}