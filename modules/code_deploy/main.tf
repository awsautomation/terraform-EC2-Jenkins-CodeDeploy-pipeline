# We will pass in the IAM role for the deployment group
variable "code_deploy_role" {
   description = "The IAM role for the code deploy deployment group"
}

# We will pass in the name tag of the web server
variable "web_server_name_tag" {
   description = "The name tag of the web server"
}

# We will pass in the application name of our application in CodeDeploy
variable "application_name" {
   description = "The name of your application in CodeDeploy"
}

# We will pass in the deployment group name of our deployment group in CodeDeploy
variable "deployment_group" {
   description = "The name of your deployment group in CodeDeploy"
}

# Create a CodeDeploy application
resource "aws_codedeploy_app" "tutorial_app" {
   # Here we are setting the compute_platform to "Server" - this means EC2
   compute_platform = "Server"
   # We are setting the name of the CodeDeploy application to the application_name variable
   name = var.application_name
}

# Create a CodeDeploy deployment group
resource "aws_codedeploy_deployment_group" "tutorial_app_deployment_group" {
   # Setting the app to the tutorial_app above
   app_name = aws_codedeploy_app.tutorial_app.name
   # Setting the name to the deployment_group variable
   deployment_group_name = var.deployment_group
   # Setting the IAM role of this deployment group to the code_deploy_role variable
   service_role_arn = var.code_deploy_role
   # Setting the deployment configuration to CodeDeployDefault.AllAtOnce
   deployment_config_name = "CodeDeployDefault.AllAtOnce"

   # Here we are specifiying that we want this deployment group
   # to control all EC2 instances that have a Name tag set to 
   # the web_server_name_tag variable
   ec2_tag_set {
      ec2_tag_filter {
         key = "Name"
         type = "KEY_AND_VALUE"
         value = var.web_server_name_tag
      }
   }
}