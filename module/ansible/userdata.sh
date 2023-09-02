#!/bin/bash

# update instance and install ansible
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt-get install ansible python3-pip -y
sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'

# Copy private key into ansible server and change its permission and ownership to ubuntu
echo "${prv_key}" >> /home/ubuntu/k8-key
sudo chmod 400 /home/ubuntu/k8-key
sudo chown ubuntu:ubuntu /home/ubuntu/k8-key

# Give ansible directory the right permission
sudo chown -R ubuntu:ubuntu /etc/ansible && chmod +x /etc/ansible
sudo chmod 777 /etc/ansible/hosts

# Copying the 1st HA-proxy IP into our ha-ip.yml
sudo echo ha_prv_ip: "${HAProxy1_IP}" >> /home/ubuntu/ha-ip.yml

# Copying the 2nd HA-proxy IP into our ha-ip.yml
sudo echo prod_Bckup_haIP: "${HAProxy2_IP}" >> /home/ubuntu/ha-ip.yml

# Updating host inventory file with all the ip addresses
sudo echo "[MastKeepalived]" >> /etc/ansible/hosts
sudo echo "${HAProxy1_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts
sudo echo "[Backup-Keepalived]" >> /etc/ansible/hosts
sudo echo "${HAProxy2_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts
sudo echo "[master-node]" >> /etc/ansible/hosts
sudo echo "${master1_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts
sudo echo "[member-master]" >> /etc/ansible/hosts
sudo echo "${master2_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts
sudo echo "${master3_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts
sudo echo "[worker-node]" >> /etc/ansible/hosts
sudo echo "${worker1_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts
sudo echo "${worker2_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts
sudo echo "${worker3_IP} ansible_ssh_private_key_file=/home/ubuntu/k8-key" >> /etc/ansible/hosts

# Executing all playbooks
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/installation.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/keepalived.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/master-node.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/member-master.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/worker-node.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/haproxy.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/stage.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/prod.yml" ubuntu
# sudo su -c "ansible-playbook /home/ubuntu/playbooks/monitoring.yml" ubuntu

sudo hostnamectl set-hostname Ansible

