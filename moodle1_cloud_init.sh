#!/bin/bash

echo "Started at $(date -R)!" >> /home/opc/install.log
sudo systemctl stop firewalld
echo "Firewall is stopped $(date -R)!" >> /home/opc/install.log

sudo yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
echo "fedore repo installed $(date -R)!" >> /home/opc/install.log

sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
echo "remi repo installed $(date -R)!" >> /home/opc/install.log

sudo yum-config-manager --enable remi-php74
echo "repo enabled $(date -R)!" >> /home/opc/install.log

sudo yum install dos2unix php php-cli php-mysqlnd php-zip php-gd  php-mcrypt php-mbstring php-xml php-json php-intl php-xmlrpc php-soap php-opcache -y
echo "php installed $(date -R)!" >> /home/opc/install.log

sudo yum install ocfs2-tools-devel ocfs2-tools -y
echo "OCFS is installed $(date -R)!" >> /home/opc/install.log

cd /var/www/

sudo rm -rf html
echo "default html dir is deleted $(date -R)!" >> /home/opc/install.log

sudo mkdir moodledata
sudo mkdir html
echo "moodledata and html dir created $(date -R)!" >> /home/opc/install.log

sudo o2cb add-cluster moodle
echo "moodle cluster is created $(date -R)!" >> /home/opc/install.log

sudo o2cb add-node moodle moodle-main1 --ip 10.20.1.7
echo "moodle node1 is added to cluster $(date -R)!" >> /home/opc/install.log

sudo o2cb add-node moodle moodle-main2 --ip 10.20.1.6
echo "moodle node2 is added to cluster $(date -R)!" >> /home/opc/install.log

(echo y; echo o2cb; echo moodle; echo 31; echo 30000; echo 2000; echo 2000) | sudo /sbin/o2cb.init configure
echo "o2cb cluster moodle is configured $(date -R)!" >> /home/opc/install.log

sudo systemctl enable o2cb
echo "o2cb is enabled on boot $(date -R)!" >> /home/opc/install.log

sudo systemctl enable ocfs2
echo "ocfs2 is enabled on boot $(date -R)!" >> /home/opc/install.log

sudo sysctl kernel.panic=30
echo "kernel parameter updated $(date -R)!" >> /home/opc/install.log

sudo sysctl kernel.panic_on_oops=1
echo "kernel parameter updated $(date -R)!" >> /home/opc/install.log

sudo mkfs.ocfs2 -L "ocfs2" /dev/sdb
echo "Disk is formatted $(date -R)!" >> /home/opc/install.log

sudo sh -c 'echo "/dev/sdb /var/www/html ocfs2     _netdev,defaults   0 0" >> /etc/fstab'
echo "fstab is updated $(date -R)!" >> /home/opc/install.log

sudo sh -c 'echo "/dev/sdc /var/www/moodledata ocfs2     _netdev,defaults   0 0" >> /etc/fstab'
echo "fstab is updated $(date -R)!" >> /home/opc/install.log

sudo wget https://download.moodle.org/download.php/direct/stable38/moodle-latest-38.tgz
echo "moodle downloaded $(date -R)!" >> /home/opc/install.log

sudo tar -xzvf moodle-latest-38.tgz
echo "moodle unzipped $(date -R)!" >> /home/opc/install.log

sudo mount -a
echo "disks are mounted $(date -R)!" >> /home/opc/install.log

sudo rsync -rtv moodle/ html/
echo "moodle is copied to html $(date -R)!" >> /home/opc/install.log

sudo chown apache. -R html moodledata
echo "folder ownership changed to apache $(date -R)!" >> /home/opc/install.log

sudo chcon --type httpd_sys_rw_content_t html
echo "chcon html $(date -R)!" >> /home/opc/install.log

sudo chcon --type httpd_sys_rw_content_t moodledata
echo "chcon moodledata $(date -R)!" >> /home/opc/install.log

sudo setsebool -P httpd_can_network_connect_db 1
echo "SELinux enabled apache $(date -R)!" >> /home/opc/install.log


sudo systemctl start httpd
echo "Apache is up and running $(date -R)!"  >> /home/opc/install.log

sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm
echo "mysql repo installed $(date -R)!" >> /home/opc/install.log

sudo yum install -y mysql-shell
echo "mysql shell installed $(date -R)!" >> /home/opc/install.log

echo "Finished at $(date -R)!" >> /home/opc/install.log

sudo systemctl disable firewalld

echo "Firewall is disabled $(date -R)!" >> /home/opc/install.log
