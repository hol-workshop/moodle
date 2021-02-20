# Moodle Cluster on OCI with MySQL database service


The this architecture contains a public load balancer, two moodle application server on Apache, two read-write shareable storages for html files, and a database tier with MySQL Database Service.
# Clone to your local machine
If you want to run this terraform from your local machine, use below commands to clone it.

    git clone https://github.com/oracle-quickstart/oci-arch-tomcat-mds.git
    cd oci-arch-tomcat-mds
    ls

# Create the Resources

Run the following commands:

terraform init
terraform plan
terraform apply
