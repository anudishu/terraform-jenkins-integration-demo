https://blog.searce.com/automation-of-infrastructure-using-jenkins-and-terraform-90b07f1bef8c

This is the link above to perform the demo. nice one!!



Automation of Infrastructure using Jenkins and Terraform
Introduction:
This document is about how to execute Terraform scripts automatically using Jenkins pipeline. We will learn how to create EC2 instance using Terraform and Jenkins in AWS cloud.

![image](https://user-images.githubusercontent.com/72337263/196380770-17621207-475f-4fc7-b52a-f2cf9bfc3dce.png)


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

provider "aws" {
  region = var.aws_region
}



# Create AWS ec2 instance
resource "aws_instance" "myFirstInstance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags= {
    Name = var.tag_name
  }
}

# Create Elastic IP address
resource "aws_eip" "myFirstInstance" {
  vpc      = true
  instance = aws_instance.myFirstInstance.id
tags= {
    Name = "my_elastic_ip"
  }
}


Make sure to create necessary IAM role in AWS with the right policy and attached to Jenkins EC2 instance. Create role with AmazonEC2FullAccess Policy.
Steps: (AWS console)
Create an IAM role to provision EC2 instance in AWS.

![image](https://user-images.githubusercontent.com/72337263/196381033-75951a72-e524-4382-a73d-9fc8d3f7d2d0.png)


2. Choose AmazonEC2FullAccess as policy for that IAM role.

![image](https://user-images.githubusercontent.com/72337263/196381071-c2744cb8-4c1d-4a40-a255-3b308b1b4c4a.png)

Steps: (Jenkins Server)
Create a new Jenkins Pipeline job with any job name.

![image](https://user-images.githubusercontent.com/72337263/196381112-b8a6ef47-ee0f-436c-8f53-1629814818d8.png)

2. Add parameters to the pipeline

Click checkbox — This project is parameterized, choose Choice Parameter

Enter name as action

type apply and enter and type destroy as choices as it is shown below(it should be in two lines)

apply

destroy

![image](https://user-images.githubusercontent.com/72337263/196381159-f821f8b2-dc9e-49bb-b192-618489d24104.png)

3. Go to Pipeline section

Add below pipeline code and modify as per GitHub repo configuration.


pipeline {
    agent any
 
    stages {
        stage('checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/re/repo_name']]])
            }
        }
        stage('init') {
            steps {
                sh ('terraform init') 
            }
        }
        stage('terraform  action') {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve')
            }
        }
    }
    
}


4.Click on Build with Parameters and choose apply to build the infrastructure or choose destroy if you like to destroy the infrastructure you have built.

![image](https://user-images.githubusercontent.com/72337263/196381337-bfaeedb5-f67f-4675-bde1-a2743beeb051.png)


5. Click on Build

Now you should see the console output if you choose to apply.

![image](https://user-images.githubusercontent.com/72337263/196381368-e26221f2-a8a1-43ed-ab7f-8cb46e90d7ce.png)



6. If something is wrong, then build the pipeline job with select destroy parameter.


7. You can see the terraform.tfstate file and other related files on location /var/lib/jenkins/workspace/job_name on Jenkins server.

Conclusion:

By using this Jenkins and terraform we can create infrastructure automation with the help of pipeline feature of Jenkins.
