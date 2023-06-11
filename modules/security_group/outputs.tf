output "jenkins_sg_id" {
   description = "The ID of the Jenkins security group"
   value = aws_security_group.tutorial_jenkins_sg.id
}

output "web_sg_id" {
   description = "The ID of the web security group"
   value = aws_security_group.web_server_sg.id
}