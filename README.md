https://blog.searce.com/automation-of-infrastructure-using-jenkins-and-terraform-90b07f1bef8c

This is the link above to perform the demo. nice one!!



Automation of Infrastructure using Jenkins and Terraform
Introduction:
This document is about how to execute Terraform scripts automatically using Jenkins pipeline. We will learn how to create EC2 instance using Terraform and Jenkins in AWS cloud.


Use Case:
Sometimes User doesn’t have direct access to the aws console to create the instance or manage the existing instance, In this case you can give Jenkins UI to the user to automate your infrastructure.

Prerequisites:
Jenkins server should be up and running.
For this demo, choose an EC2 machine which is Amazon Linux with Security group (open port 22, 8080).

then install java, Jenkins on the server and start a Jenkins service on the server. For documentation Click here.

Setup prerequisites on Jenkins GUI ( install required plugins).

Install Terraform on Jenkins server.
Below are the steps to install terraform on Jenkins server.

Note: To install terraform on other operating systems click here.

$sudo wget https://releases.hashicorp.com/terraform/1.1.7/terraform_1.1.7_linux_amd64.zip

$ sudo unzip terraform_1.1.7_linux_amd64.zip

[ec2-user@ip-172–31–92–134 terraform]$ ll

ec2-user@ip-172–31–92–134 terraform]$ mv terraform /usr/local/bin/terraform

mv: try to overwrite ‘/usr/local/bin/terraform’, overriding mode 0755 (rwxr-xr-x)?

[ec2-user@ip-172–31–92–134 terraform]$ sudo mv terraform /usr/local/bin/terraform

[ec2-user@ip-172–31–92–134 terraform]$ terraform -v

Terraform v1.1.7

Terraform files (main.tf and variable.tf files) already created in SCM (Github).


Make sure to create necessary IAM role in AWS with the right policy and attached to Jenkins EC2 instance. Create role with AmazonEC2FullAccess Policy.
Steps: (AWS console)
Create an IAM role to provision EC2 instance in AWS.

2. Choose AmazonEC2FullAccess as policy for that IAM role.


Steps: (Jenkins Server)
Create a new Jenkins Pipeline job with any job name.

2. Add parameters to the pipeline

Click checkbox — This project is parameterized, choose Choice Parameter

Enter name as action

type apply and enter and type destroy as choices as it is shown below(it should be in two lines)

apply

destroy


3. Go to Pipeline section

Add below pipeline code and modify as per GitHub repo configuration.


4.Click on Build with Parameters and choose apply to build the infrastructure or choose destroy if you like to destroy the infrastructure you have built.


5. Click on Build

Now you should see the console output if you choose to apply.


6. If something is wrong, then build the pipeline job with select destroy parameter.


7. You can see the terraform.tfstate file and other related files on location /var/lib/jenkins/workspace/job_name on Jenkins server.

Conclusion:

By using this Jenkins and terraform we can create infrastructure automation with the help of pipeline feature of Jenkins.
