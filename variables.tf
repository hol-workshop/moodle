variable "tenancy_ocid" {}
variable "region" {}
variable "compartment_ocid" {}

variable "mysql_admin_password" {
  default = "MySQLAdm1n_"
}
variable "mysql_admin_user" {
  default = "root"
}
variable "moodle_admin_password" {
  default = "MoodleAdm1n_"
}
variable "moodle_admin_user" {
  default = "moodle"
}
variable "moodle_database" {
  default = "moodle"
}

variable "instance_name1" {
  default = "moodle_main1"
}
variable "instance_name2" {
  default = "moodle_main2"
}

variable "vcn_moodle_cidr_block" {
  default = "10.20.0.0/16"
}
variable "vcn_moodle_dns_label" {
  default = "vcnmoodle"
}
variable "vcn_moodle_display_name" {
  default = "vcn_moodle"
}

variable "vcn_moodle_public_subnet_cidr_block" {
  default = "10.20.0.0/24"
}

variable "vcn_moodle_public_subnet_display_name" {
  default = "vcn_moodle_public_subnet"
}

variable "vcn_moodle_private_subnet_cidr_block" {
  default = "10.20.1.0/24"
}

variable "vcn_moodle_private_subnet_display_name" {
  default = "vcn_moodle_private_subnet"
}
variable "secondary_vnic_count" {
  default = 1
}
variable "num_instances" {
  default = "1"
}

variable "num_moodle" {
  default = "2"
}

variable "num_iscsi_volumes_per_instance" {
  default = "1"
}

variable "instance_shape" {
  default = "VM.Standard.E2.2"
}

variable "db_size" {
  default = "50" # size in GBs
}

variable "instance_image_ocid" {
  type = map(string)

  default = {
    us-phoenix-1   = "ocid1.image.oc1.phx.aaaaaaaaptdwhdot3iosccxikn3oqb3l2qew7c5mcryixlulpn4diszgncfq"
    us-ashburn-1   = "ocid1.image.oc1.iad.aaaaaaaaqdc7jslbtue7abhwvxaq3ihvazfvihhs2rwk2mvciv36v7ux5sda"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa5w2lrmsn6wpjn7fbqv55curiarwsryqhoj4dw5hsixrl37hrinja"
	us-sanjose-1   = "ocid1.image.oc1.us-sanjose-1.aaaaaaaag2fam5xawz7t3ad5u3mzxdhglxeldohlijdsjfaielqluysrc3ga"
	us-langley-1   = "ocid1.image.oc2.us-langley-1.aaaaaaaahkwvd2ix7nfz3nykrteghnio6hzrzrxudvwmu47q3swl2eglxrja"
    us-luke-1	   = "ocid1.image.oc2.us-luke-1.aaaaaaaa4zoccgg4qj4uilfyhiwcbupz66fejyyogwbuazyuuennxjtwlvba"
  }
}

variable "num_load_balancer" {
  default = "1"
}
variable "num_back_end" {
  default = "1"
}