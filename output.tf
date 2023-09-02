output "ansible-server" {
  value = module.ansible.ansible-server-ip
}

output "jenkins-server" {
  value = module.jenkins.jenkins-server-ip
}

output "jenkins-lb" {
  value = module.jenkins.jenkins-lb
}

output "masternode-ip" {
  value = module.master-nodes.master-nodes_priv-ip
}

output "workernode-ip" {
  value = module.worker-nodes.Worker_nodes_private_ip
}

output "haproxy-ip" {
  value = module.haproxy-servers.HAproxy_private_IP
}

output "HAproxybackup-private-IP" {
  value = module.haproxy-servers.HAproxybackup_private_IP
}

output "bastion-ip" {
  value = module.bastion.bastion-ip
}

output "certificate_arn" {
  value = module.ssl-certf.certificate_arn
}

output "route53-server" {
  value = module.route53.route53_dns-name
}