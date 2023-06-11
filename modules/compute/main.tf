# Variable where we will pass our Jenkins security group ID 
variable "jenkins_security_group" {
  description = "The security group for the Jenkins server"
}

# Variable where we will pass in our web security group ID
variable "web_security_group" {
  description = "The security group for the web server"
}

# Variable where we will pass in our IAM instance profile for the web server
variable "web_instance_profile" {
  description = "The IAM instance profile of the web server"
}

# Variable where we will pass in the subnet ID
variable "public_subnet" {
  description = "The public subnet for the Jenkins server"
}

# Variable where we will pas in the AWS region
variable "aws_region" {
  description = "The AWS region we are deploying in"
}

# This data store is holding the most recent ubuntu 20.04 image
data "aws_ami" "ubuntu" {
  most_recent = "true"

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

# Creating a key pair in AWS called tutorial_kp
resource "aws_key_pair" "tutorial_kp" {
  # Naming the key tutorial_kp
  key_name = "tutorial_kp"
  
  # Passing the public key of the key pair we created
  public_key = file("${path.module}/tutorial_kp.pub")
}

# Creating an EC2 instance called jenkins_server
resource "aws_instance" "jenkins_server" {
  # Setting the AMI to the ID of the Ubuntu 20.04 AMI from the data store
  ami = data.aws_ami.ubuntu.id
  
  # Setting the subnet to the public subnet we created
  subnet_id = var.public_subnet
  
  # Setting the instance type to t2.micro
  instance_type = "t2.micro"
  
  # Setting the security group to the security group we created
  vpc_security_group_ids = [var.jenkins_security_group]
  
  # Setting the key pair name to the key pair we created
  key_name = aws_key_pair.tutorial_kp.key_name
  
  # Setting the user data to the bash file called install_jenkins.sh
  user_data = "${file("${path.module}/install_jenkins.sh")}"

  # Setting the Name tag to jenkins_server
  tags = {
    Name = "jenkins_server"
  }
}

# Creating an EC2 instance called web_server
resource "aws_instance" "web_server" {
  # Setting the AMI to the ID of the Ubuntu 20.04 AMI from the data store
  ami = data.aws_ami.ubuntu.id
  
  # Setting the subnet to the public subnet we created
  subnet_id = var.public_subnet
  
  # Setting the instance type to t2.micro
  instance_type = "t2.micro"
  
  # Setting the security group to the security group we created
  vpc_security_group_ids = [var.web_security_group]
  
  # Setting the key pair name to the key pair we created
  key_name = aws_key_pair.tutorial_kp.key_name
  
  # Setting the user data to our script we created called install_webserver.tftpl
  # and passing in the variable aws_region
  user_data = templatefile("${path.module}/install_webserver.tftpl", { aws_region = var.aws_region })

  # Setting the IAM Instance Prfile to the variable web_instance_profile
  iam_instance_profile = var.web_instance_profile

  # Setting the Name tag to web_server
  tags = {
    Name = "web_server"
  }
}

# Creating an Elastic IP called jenkins_eip
resource "aws_eip" "jenkins_eip" {
  # Attaching it to the jenkins_server EC2 instance
  instance = aws_instance.jenkins_server.id
  
  # Making sure it is inside the VPC
  vpc = true

  # Setting the tag Name to jenkins_eip
  tags = {
    Name = "jenkins_eip"
  }
}

# Creating an Elastic IP called web_eip
resource "aws_eip" "web_eip" {
  # Attaching it to the web_server EC2 instance
  instance = aws_instance.web_server.id
  
  # Making sure it is inside the VPC
  vpc = true

  # Setting the tag Name to web_eip
  tags = {
    Name = "web_eip"
  }
}