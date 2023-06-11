variable "release_s3_bucket_name" {
   description = "S3 bucket where releases are stored"
}

variable "aws_region" {
   description = "AWS region where code deploy is"
}

# Get the AWS managed AWSCodeDeployRole policy
data "aws_iam_policy" "aws_code_deploy_role" {
   name = "AWSCodeDeployRole"
}

# Get the AWS managed AmazonSSMManagedInstanceCore policy 
data "aws_iam_policy" "aws_ssm_policy" {
   name = "AmazonSSMManagedInstanceCore"
}

# Create a role called CodeDeployRole
resource "aws_iam_role" "code_deploy_role" {
   name = "CodeDeployRole"

   # Assume the following policy
   # This is giving the CodeDeployRole access to the CodeDeploy service
   assume_role_policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
         {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
               "Service": "codedeploy.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
         }
      ]
   })
}

# Here we are attaching the AWS managed policy AWSCodeDeployRole to the
# CodeDeployRole we create dabove
resource "aws_iam_role_policy_attachment" "code_deploy_role_attachment" {
   # The name of the CodeDeployRole
   role = aws_iam_role.code_deploy_role.name
   # The ARN of the AWSCodeDeployRole
   policy_arn = data.aws_iam_policy.aws_code_deploy_role.arn
}

# Here we are creating a data object to hold an IAM policy document
# for our EC2 instance that will give the EC2 instance full Get and List access to our 
# release s3 bucket and the CodeDeploy bucket in our region
data "aws_iam_policy_document" "ec2_code_deploy_policy" {
   statement {
      actions = [
         "s3:Get*",
         "s3:List*"
      ]
      
      resources = [
         "arn:aws:s3:::${var.release_s3_bucket_name}/*", 
         "arn:aws:s3:::aws-codedeploy-${var.aws_region}/*"
      ]
   }
}

# Here we are creating a role for our EC2 instance
resource "aws_iam_role" "ec2_code_deploy_instance_role" {
   name = "EC2CodeDeployInstanceRole"

   # Assume the following policy
   # This is giving this access to the EC2 service
   assume_role_policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
         {
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Sid = ""
            Principal = {
               Service = "ec2.amazonaws.com"
            }
         }
      ]
   })

   # We are creating an inline policy and attaching the IAM 
   # policy document we created above called ec2_code_deploy_policy
   inline_policy {
     name = "EC2CodeDeployPolicy"
     policy = data.aws_iam_policy_document.ec2_code_deploy_policy.json
   }

}

# We are attaching the AmazonSSMManagedInstanceCore policy to 
# our EC2CodeDeployInstanceRole IAM role
resource "aws_iam_role_policy_attachment" "ec2_role_policy_attach" {
   # The role we want to attach the policy to
   role = aws_iam_role.ec2_code_deploy_instance_role.name
   # The policy we want to attach to the above role
   policy_arn = data.aws_iam_policy.aws_ssm_policy.arn
}

# Here we are creating an IAM instance profile that we will use to 
# attach our IAM role to our web server
resource "aws_iam_instance_profile" "ec2_code_deploy_instance_profile" {
   # The name of the IAM instance profile
   name = "EC2CodeDeployInstanceProfile"
   # The role we want attached to this instance profile
   role = aws_iam_role.ec2_code_deploy_instance_role.name
}

### This section we are creating an IAM user for our Jenkins server
### that will have access to CodeDeploy and S3

# Grab the AWS managed policy called AWSCodeDeployFullAccess
data "aws_iam_policy" "aws_code_deploy_policy" {
   name = "AWSCodeDeployFullAccess"
}

# Grab the AWS managed policy called AmazonS3FullAccess
data "aws_iam_policy" "aws_s3_policy" {
   name = "AmazonS3FullAccess"
}

# Create an IAM user named jenkins_user
resource "aws_iam_user" "jenkins_user" {
   name = "jenkins_user"
}

# Create an IAM access key and access it to the jenkins_user user
resource "aws_iam_access_key" "jenkins_user_key" {
   user = aws_iam_user.jenkins_user.name
}

# Attach the CodeDeploy policy to the jenkins_user user
resource "aws_iam_user_policy_attachment" "jenkins_user_attach_cd" {
   user = aws_iam_user.jenkins_user.name
   policy_arn = data.aws_iam_policy.aws_code_deploy_policy.arn
}

# Attach the S3 policy to the jenkins_user user
resource "aws_iam_user_policy_attachment" "jenkins_user_attach_s3" {
   user = aws_iam_user.jenkins_user.name
   policy_arn = data.aws_iam_policy.aws_s3_policy.arn
}