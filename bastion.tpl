#!/bin/bash

echo "Started at $(date -R)!" >> /home/opc/install.log

echo "${ssh_private_key}" >> /home/opc/.ssh/id_rsa
echo "ssh key copied to directory $(date -R)!" >> /home/opc/install.log

chmod 600 /home/opc/.ssh/id_rsa
echo "ssh key modifed up $(date -R)!" >> /home/opc/install.log

chown -R opc /home/opc/.ssh/authorized_keys
echo "auth key owner modifed $(date -R)!" >> /home/opc/install.log

chown -R opc /home/opc/.ssh/id_rsa
echo "ssh key owner modifed $(date -R)!" >> /home/opc/install.log

sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
echo "mysql repo installed $(date -R)!" >> /home/opc/install.log

sudo yum install -y mysql-shell
echo "mysql shell installed $(date -R)!" >> /home/opc/install.log

sudo mysqlsh --sql --user=${mysql_admin_user} --host=${mysql_host} --password=${mysql_admin_password} -e "create database moodle"
echo "mysql moodle database created $(date -R)!" >> /home/opc/install.log

sudo mysqlsh --sql --user=${mysql_admin_user} --host=${mysql_host} --password=${mysql_admin_password} -e "create user moodle identified by 'MoodleAdm1n_';"
echo "mysql moodle user created $(date -R)!" >> /home/opc/install.log

sudo mysqlsh --sql --user=${mysql_admin_user} --host=${mysql_host} --password=${mysql_admin_password} -e "grant all privileges on moodle.* to moodle"
echo "mysql granted privileges to moodle user $(date -R)!" >> /home/opc/install.log


echo "Finished at $(date -R)!" >> /home/opc/install.log