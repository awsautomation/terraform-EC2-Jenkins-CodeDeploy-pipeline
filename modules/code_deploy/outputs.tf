output "code_deploy_app" {
   description = "The CodeDeploy application name"
   value = aws_codedeploy_app.tutorial_app.name
}

output "code_deploy_deployment_group" {
   description = "The CodeDeploy deployment group name"
   value = aws_codedeploy_deployment_group.tutorial_app_deployment_group.deployment_group_name
}