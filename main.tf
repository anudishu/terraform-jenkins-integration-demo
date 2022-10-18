
provider "aws" {
  region = var.aws_region
  access_key = "AKIA36BKGJXL2IMLMOHZ"
  secret_key = "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"
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