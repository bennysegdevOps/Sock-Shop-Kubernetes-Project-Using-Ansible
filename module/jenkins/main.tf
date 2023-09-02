#Create Jenkins Server
resource "aws_instance" "jenkins_server" {
  ami                     = var.ami
  instance_type           = var.instance_type
  vpc_security_group_ids  = var.jenkins-sg
  subnet_id               = var.prvtsub1-id 
  key_name                = var.keypair
  user_data               = local.jenkins-userdata 

  tags = {
    Name = var.tags   
  }
}

resource  "aws_elb" "jenkins_lb" { 
  name              = "jenkins"
  subnets           = var.subnet_id2
  security_groups   = var.jenkins-sg
  listener {
    instance_port   = 8080 
    instance_protocol = "http" 
    lb_port         = 80 
    lb_protocol     = "http" 
  }
health_check{
  healthy_threshold = 2 
  unhealthy_threshold = 2 
  timeout            = 3 
  target            = "TCP:8080" 
  interval          = 30 

}
instances                 = [aws_instance.jenkins_server.id] 
cross_zone_load_balancing = true 
idle_timeout              = 400 
connection_draining       = true 
}