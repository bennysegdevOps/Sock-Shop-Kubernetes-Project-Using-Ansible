module "vpc" {
  source                     = "./module/vpc"
  vpc_cidr                   = "10.0.0.0/16"
  public_subnet1_cidr        = "10.0.1.0/24"
  public_subnet2_cidr        = "10.0.2.0/24"
  public_subnet3_cidr        = "10.0.3.0/24"
  private_subnet1_cidr       = "10.0.4.0/24"
  private_subnet2_cidr       = "10.0.5.0/24"
  private_subnet3_cidr       = "10.0.6.0/24"
  az1                        = "eu-west-1a" #"eu-west-3a"
  az2                        = "eu-west-1b" #"eu-west-3b"
  az3                        = "eu-west-1c" #"eu-west-3c"
  rt-cidr                    = "0.0.0.0/0"
  RT_cidr                    = "0.0.0.0/0"
  port_ssh                   = 22
  port_proxy                 = 8080
  port_https                 = 443
  node-port                  = 0
  node-port2                 = 65535
  port                       = 80
  tag-vpc                    = "${local.name}-vpc"
  tag-public_subnet1         = "${local.name}-public_subnet1"
  tag-public_subnet2         = "${local.name}-public_subnet2"
  tag-public_subnet3         = "${local.name}-public_subnet3"
  tag-private_subnet1        = "${local.name}-private_subnet1"
  tag-private_subnet2        = "${local.name}-private_subnet2"
  tag-private_subnet3        = "${local.name}-private_subnet3"
  tag-igw                    = "${local.name}-igw"
  tag-natgw                  = "${local.name}-natgw"
  master-worker-SG           = "${local.name}-master-worker-SG"
  Jenkins_SG                 = "${local.name}-Jenkins_SG"
  Bastion_Ansible_SG         = "${local.name}-Bastion_Ansible_SG"
}

module "ansible" {
  source        = "./module/ansible"
  ami_ubuntu    = "ami-01dd271720c1ba44f" #"ami-05b5a865c3579bbc4"
  instance_type = "t2.micro"
  key_name      = module.vpc.keypairid 
  ansible-sg    = [module.vpc.Bastion_Ansible_SG]
  subnet_id     = module.vpc.private-subnet3
  prv_key       = module.vpc.privatekeypair
  HAProxy1_IP   = module.haproxy-servers.HAproxy_private_IP
  HAProxy2_IP   = module.haproxy-servers.HAproxybackup_private_IP
  master1_IP    = module.master-nodes.master-nodes_priv-ip [0]
  master2_IP    = module.master-nodes.master-nodes_priv-ip [1]
  master3_IP    = module.master-nodes.master-nodes_priv-ip [2]
  worker1_IP    = module.worker-nodes.Worker_nodes_private_ip [0]
  worker2_IP    = module.worker-nodes.Worker_nodes_private_ip [1]
  worker3_IP    = module.worker-nodes.Worker_nodes_private_ip [2]
  ansible_server = "${local.name}-ansible-server"
  bastion_host  = module.bastion.bastion-ip
}

module "bastion" {
  source               = "./module/bastion"
  ami                  = "ami-01dd271720c1ba44f" #"ami-05b5a865c3579bbc4"
  instance_type        = "t2.micro"
  bastion-SG           = [module.vpc.Bastion_Ansible_SG]
  key_name             = module.vpc.keypairid
  subnetid             = module.vpc.public-subnet1
  private_keypair_path = module.vpc.privatekeypair
  tags                 = "${local.name}-bastion-host"
}

module "ssl-certf" {
  source = "./module/ssl-certf"
  domain_name = "thinkeod.com"
  domain_name2 = "*.thinkeod.com"
}

module "jenkins" {
  source               = "./module/jenkins"
  ami                  = "ami-013d87f7217614e10" #"ami-0d767e966f3458eb5"
  instance_type        = "t2.medium"
  jenkins-sg           = [module.vpc.jenkins_sg]
  keypair              = module.vpc.keypairid
  subnet_id2           = [module.vpc.public-subnet1, module.vpc.public-subnet2, module.vpc.public-subnet3]
  prvtsub1-id          = module.vpc.private-subnet1
  tags                 = "${local.name}-jenkins_server" 
}
    
#create haproxy1, haproxybackup server
module "haproxy-servers"{
  source             = "./module/haproxy-servers"
  keypair            = module.vpc.keypairid
  ami                = "ami-01dd271720c1ba44f" #"ami-05b5a865c3579bbc4"
  instance_type      = "t2.medium"
  private_subnet1    = module.vpc.private-subnet1
  private_subnet2    = module.vpc.private-subnet2
  haproxy_sg         = module.vpc.master-worker-SG
  master1            = module.master-nodes.master-nodes_priv-ip [0]
  master2            = module.master-nodes.master-nodes_priv-ip [1]
  master3            = module.master-nodes.master-nodes_priv-ip [2]
  master4            = module.worker-nodes.Worker_nodes_private_ip [0]
  master5            = module.worker-nodes.Worker_nodes_private_ip [1]
  master6            = module.worker-nodes.Worker_nodes_private_ip [2]
  tag1               = "${local.name}-haproxy"
  tag2               = "${local.name}-haproxy-backup"
}

# create worker-nodes
module "worker-nodes" {
  source = "./module/worker-nodes"
  instance-count = 3
  ami-ubuntu = "ami-01dd271720c1ba44f" #"ami-05b5a865c3579bbc4"
  instanceType = "t3.medium"
  worker-node-sg = [module.vpc.master-worker-SG]
  prvsub-id = [module.vpc.private-subnet1, module.vpc.private-subnet2, module.vpc.private-subnet3]
  pub-key = module.vpc.keypairid
  instance_worker = "${local.name}-worker-nodes"
}

# create master nodes
module "master-nodes" {
  source = "./module/master-nodes"
  instance-count = 3
  ubuntu-ami = "ami-01dd271720c1ba44f" #"ami-05b5a865c3579bbc4"
  instance-Type = "t3.medium"
  master-node-sg = [module.vpc.master-worker-SG]
  prvsubnet-id = [module.vpc.private-subnet1, module.vpc.private-subnet2, module.vpc.private-subnet3]
  key-name = module.vpc.keypairid
  instance_worker = "${local.name}-master-nodes"
}

# Creating Grafana load balancer
module "grafana-lb" {
  source = "./module/grafana-lb"
  vpc_id = module.vpc.vpc-id
  subnets = [module.vpc.public-subnet1, module.vpc.public-subnet2, module.vpc.public-subnet3]
  security_groups = [module.vpc.master-worker-SG]
  certificate = module.ssl-certf.certificate_arn
}

# Creating Prometheus load balancer
module "prometheus-lb" {
  source = "./module/prometheus-lb"
  vpc_id = module.vpc.vpc-id
  subnets = [module.vpc.public-subnet1, module.vpc.public-subnet2, module.vpc.public-subnet3]
  security_groups = [module.vpc.master-worker-SG]
  certificate     = module.ssl-certf.certificate_arn
}

# Creating prod load balancer
module "prod-lb" {
  source = "./module/prod-lb"
  vpc_id = module.vpc.vpc-id
  subnets = [module.vpc.public-subnet1, module.vpc.public-subnet2, module.vpc.public-subnet3]
  certificate = module.ssl-certf.certificate_arn
  security_groups = [module.vpc.master-worker-SG]
  instance = module.worker-nodes.Worker_nodes_id
}

# Creating stage load balancer
module "stage-lb" {
  source = "./module/stage-lb"
  vpc_id = module.vpc.vpc-id
  subnets = [module.vpc.public-subnet1, module.vpc.public-subnet2, module.vpc.public-subnet3]
  certificate     = module.ssl-certf.certificate_arn
  security_groups = [module.vpc.master-worker-SG]
  instance = module.worker-nodes.Worker_nodes_id
}

# Creating Route53 
module "route53" {
  source                  = "./module/route53"
  domain_name             = "thinkeod.com"
  prod_lb_dns_name        = module.prod-lb.prod-dns-name
  prod_lb_zone_id         = module.prod-lb.prod-zoneid
  stage_domain_name       = "stage.thinkeod.com"
  stage_lb_dns_name       = module.stage-lb.stage-dns-name
  stage_lb_zone_id        = module.stage-lb.stage-zoneid
  prometheus_domain_name  = "prometheus.thinkeod.com"
  prometheus_lb_dns_name  = module.prometheus-lb.prometheus-dns-name
  prometheus_lb_zone_id   = module.prometheus-lb.prometheus-zoneid
  grafana_domain_name     = "grafana.thinkeod.com"
  grafana_lb_dns_name     = module.grafana-lb.grafana-dns-name
  grafana_lb_zone_id      = module.grafana-lb.grafana-zoneid
}