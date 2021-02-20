# Moodle Cluster on OCI with MySQL database service


The this architecture contains a public load balancer, two moodle application server on Apache, two read-write shareable storages for html files, and a database tier with MySQL Database Service.

![](diagram.PNG)

### Architecture Review
- A virtual cloud network with a public and a private subnet to avoid direct access from the public internet, hence you will have a public load balancer. Because you will not want to expose your application servers, just a thought.
- Your application servers will run in the private network 
- Two read-write shareable block storages for your cluster files.
- MySQL, enterprise-level database cloud service running on OCI in the private subnet.
- A bastion server will grant your access wish to your application servers and MySQL Database service.

## Deploy using Resource Manager

1. If you have your cloud tenancy running ready and ready to start with this deployment on using resource manager stack, which is automated terraform manager [click here](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/hol-workshop/moodle/archive/main.zip) and will re-direct you to OCI.
2. Review and accept the terms and conditions.
3. Select the region where you want to deploy the stack.
4. Follow the on-screen prompts and instructions to create the stack.
5. After creating the stack, click Terraform Actions, and select Plan.
6. Wait for the job to be completed, and review the plan.
7. To make any changes, return to the Stack Details page, click Edit Stack, and make the required changes. Then, run the Plan action again.
If no further changes are necessary, return to the Stack Details page, click Terraform Actions, and select Apply.

### Clone to your local machine
If you want to run this terraform from your local machine, use below commands to clone it.

    git clone https://github.com/hol-workshop/moodle.git
    cd moodle
    ls

### Environment parameters

    variable "tenancy_ocid" {}
    variable "region" {}
    variable "compartment_ocid" {}

#### Create the Resources

Once you are in your downloaded diretory, run the following commands:

    terraform init
    terraform plan
    terraform apply

# Test

Now it's time to check your connectivity.



