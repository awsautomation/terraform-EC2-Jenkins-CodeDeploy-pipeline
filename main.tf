terraform {
   required_providers {
      aws = {
         source = "hashicorp/aws"
         version = "4.0.0"
      }
   }

   required_version = "~> 1.1.5"
}

provider "aws" {
   region = var.aws_region
}


module "vpc" {
   source = "./modules/vpc"

   vpc_cidr_block = var.vpc_cidr_block
   public_subnet_cidr_block = var.public_subnet_cidr_block
}

module "security_group" {
   source = "./modules/security_group"
   vpc_id = module.vpc.vpc_id
   my_ip = var.my_ip
}

# DELETE THE module "ec2-instance" block and replace it with
# this "compute" module
module "compute" {
  source = "./modules/compute"
  jenkins_security_group = module.security_group.jenkins_sg_id
  web_security_group = module.security_group.web_sg_id
  public_subnet = module.vpc.public_subnet_id
  web_instance_profile = module.iam.ec2_instance_profile
  aws_region = var.aws_region
}
    
# Adding the IAM module
module "iam" {
  source = "./modules/iam"
  release_s3_bucket_name = module.s3.release_s3_bucket_name
  aws_region = var.aws_region
}
  
# Adding the CodeDeploy module
module "code_deploy" {
  source = "./modules/code_deploy" 
  web_server_name_tag = module.compute.web_server_name_tag
  code_deploy_role = module.iam.codedeploy_iam_role_arn
  application_name = var.application_name
  deployment_group = var.deployment_group_name
}

# Adding the S3 module
module "s3" {
  source = "./modules/s3"
  release_s3_bucket_name = var.release_s3_bucket_name
}