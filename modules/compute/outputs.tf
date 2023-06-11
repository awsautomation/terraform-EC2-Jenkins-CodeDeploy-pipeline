output "jenkins_public_ip" {
  description = "The public IP address of the Jenkins server"
  value = aws_eip.jenkins_eip.public_ip
}

output "web_public_ip" {
  description = "The public IP address of the web server"
  value = aws_eip.web_eip.public_ip
}

output "web_server_name_tag" {
  description = "The Name tag of the web server"
  value = aws_instance.web_server.tags_all["Name"]
}