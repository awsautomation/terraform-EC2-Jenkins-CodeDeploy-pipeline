
# Terraform Config from Pipeline Blog

This is the Terraform setup that I used in my blog. The blog can be viewed [here](https://medium.com/@TheMattLittle/provisioning-an-automated-ci-cd-pipeline-with-jenkins-and-codedeploy-on-aws-and-using-terraform-to-e4d19d1b8d00).

  

## Prerequisites

- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) installed and configuration

- [Terraform](https://www.terraform.io/downloads) installed

  

# Instructions

  

### Clone the repo

Run: `git clone https://github.com/dispact/pipeline-blog-terraform.git`

  

### Create a Secrets file

Create a file called **secrets.tfvars** and populate it with: `my_ip="0.0.0.0"` with 0.0.0.0 being your IP address

  

### Create a Key Pair

`ssh-keygen -t rsa -b 4096 -m pem -f tutorial_kp && mv tutorial_kp.pub modules/compute/tutorial_kp.pub && mv tutorial_kp tutorial_kp.pem && chmod 400 tutorial_kp.pem`

  

### Run Terraform

- Initialize terrafom: `terraform init`

- Run: `terraform apply -var-file="secrets.tfvars"`

- When prompted, enter: `yes`

  

### To SSH into the Jenkins Server

`ssh -i tutorial_kp.pem ubuntu@$(terraform output -raw jenkins_public_ip)`

  

### To SSH into the Web Server

`ssh -i tutorial_kp.pem ubuntu@$(terraform output -raw jenkins_public_ip)`

  

### To destroy everything Terraform built

`terraform destroy -var-file="secrets.tfvars"`
