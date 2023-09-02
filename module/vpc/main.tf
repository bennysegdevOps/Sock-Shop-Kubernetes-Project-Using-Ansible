# Create Custom vpc
resource "aws_vpc" "vpc" {
   cidr_block = var.vpc_cidr
   instance_tenancy = "default"

   tags = {
     Name = var.tag-vpc 
   }
}

# Creating public subnet 1
resource "aws_subnet" "public_subnet1" {
  vpc_id             = aws_vpc.vpc.id
  cidr_block         = var.public_subnet1_cidr
  availability_zone  = var.az1
  tags = {
    Name = var.tag-public_subnet1
  }
}

#Creating public subnet 2
resource "aws_subnet" "public_subnet2" {
  vpc_id            =  aws_vpc.vpc.id
  cidr_block        =  var.public_subnet2_cidr
  availability_zone =  var.az2
  tags = {
    Name = var.tag-public_subnet2
  }
}

# Creating public subnet 3
resource "aws_subnet" "public_subnet3" {
  vpc_id             = aws_vpc.vpc.id
  cidr_block         = var.public_subnet3_cidr
  availability_zone  = var.az3
  tags = {
    Name = var.tag-public_subnet3
  }
}
# Creating private subnet 1
resource "aws_subnet" "private_subnet1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.az1
  tags = {
    Name = var.tag-private_subnet1
  }
}

# Creating private subnet 2
resource "aws_subnet" "private_subnet2" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.az2
  tags = {
    Name = var.tag-private_subnet2
  }
}

# Creating private subnet 3
resource "aws_subnet" "private_subnet3" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet3_cidr
  availability_zone  = var.az3
  tags = {
    Name = var.tag-private_subnet3
  } 
}

# Creating internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  
  tags = {
    Name = var.tag-igw
  }
}

# Creating Nat Gateway
resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet2.id

  tags = {
    Name = var.tag-natgw
  }
}

#Creating EIP
resource "aws_eip" "eip" {
    domain = "vpc"
    depends_on = [ aws_internet_gateway.igw ]
}

#Creating Public Route Table 
resource "aws_route_table" "public-route-table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = var.rt-cidr
        gateway_id = aws_internet_gateway.igw.id
    }
}

#Creating Private Route Table
resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.vpc.id
    route {
        cidr_block = var.rt-cidr
        gateway_id = aws_nat_gateway.natgw.id
      }
}

#Creating public route table assoc with pub sub
resource "aws_route_table_association" "pub-ass-sub1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "pub-ass-sub2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_route_table_association" "pub-ass-sub3" {
  subnet_id      = aws_subnet.public_subnet3.id
  route_table_id = aws_route_table.public-route-table.id
}

#Creating public route table assoc with priv sub1 
resource "aws_route_table_association" "priv-ass-sub1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private-route-table.id
}

#Creating public route table assoc with priv sub2 
resource "aws_route_table_association" "priv-ass-sub2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private-route-table.id
}

#Creating public route table assoc with priv sub3 
resource "aws_route_table_association" "priv-ass-sub3" {
  subnet_id      = aws_subnet.private_subnet3.id
  route_table_id = aws_route_table.private-route-table.id
}


# Security Group for Bastion Host and Ansible server
resource "aws_security_group" "Bastion_Ansible_SG" {
  name        = "Bastion_Ansible_SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = var.Bastion_Ansible_SG
  }
}

# Security Group for master and worker nodes
resource "aws_security_group" "master-worker-SG" {
  name        = "master-worker-SG"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = var.node-port
    to_port          = var.node-port2
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = var.master-worker-SG
  }
}

# Security Group for Jenkins Server 
resource "aws_security_group" "Jenkins_SG" {
  name        = "Jenkins"
  description = "Allow inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Allow ssh access"
    from_port        = var.port_ssh
    to_port          = var.port_ssh
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = var.port_proxy
    to_port          = var.port_proxy
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow proxy access"
    from_port        = var.port_https
    to_port          = var.port_https
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  ingress {
    description      = "Allow port access"
    from_port        = var.port
    to_port          = var.port
    protocol         = "tcp"
    cidr_blocks      = [var.RT_cidr]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.RT_cidr]
  }

  tags = {
    Name = var.Jenkins_SG
  }
}

#creating keypair
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

#create local file for private keypair
resource "local_file" "keypair-file" {
  content  = tls_private_key.keypair.private_key_pem
  filename = "keypair.pem"
  file_permission = "600"
}

#creating public key resources
resource "aws_key_pair" "key_pair" {
  key_name   = "keypair"
  public_key = tls_private_key.keypair.public_key_openssh
}