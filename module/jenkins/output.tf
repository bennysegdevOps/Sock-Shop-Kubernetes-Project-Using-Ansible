output "jenkins-server-ip" {
  value = aws_instance.jenkins_server.private_ip
}

output "jenkins-lb" {
  value = aws_elb.jenkins_lb.dns_name
}