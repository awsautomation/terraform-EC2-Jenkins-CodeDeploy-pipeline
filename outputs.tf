output "jenkins_public_ip" {
   description = "The public IP address of the Jenkins server"
   value = module.compute.jenkins_public_ip
}

output "web_public_ip" {
   description = "The public IP address of the web server"
   value = module.compute.web_public_ip
}

output "release_s3_bucket_name" {
   description = "The name of the release S3 bucket"
   value = module.s3.release_s3_bucket_name
}

output "jenkins_user_access_key" {
   description = "The access key of the Jenkins user"
   value = module.iam.jenkins_user_access_key
}

output "jenkins_user_secret" {
   description = "The secret of the Jenkins user" 
   value = module.iam.jenkins_user_secret
   sensitive = true
}

output "code_deploy_application" {
   description = "The application name"
   value = module.code_deploy.code_deploy_app
}

output "code_deploy_deployment_group" {
   description = "The deployment group name"
   value = module.code_deploy.code_deploy_deployment_group
}