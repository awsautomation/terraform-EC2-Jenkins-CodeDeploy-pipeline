output "ec2_instance_profile" {
   description = "The IAM instance profile for the web server"
   value = aws_iam_instance_profile.ec2_code_deploy_instance_profile.id
}

output "codedeploy_iam_role_arn" {
   description = "The IAM role for the code deploy deployment group"
   value = aws_iam_role.code_deploy_role.arn
}

output "jenkins_user_access_key" {
   description = "The access key of the Jenkins user"
   value = aws_iam_access_key.jenkins_user_key.id
}

output "jenkins_user_secret" {
   description = "The secret of the Jenkins user" 
   value = aws_iam_access_key.jenkins_user_key.secret
   sensitive = true
}