#create haproxy server
resource "aws_instance" "haproxy"{
    ami                         = var.ami
    instance_type               = var.instance_type
    subnet_id                   = var.private_subnet1
    vpc_security_group_ids      = [var.haproxy_sg]
    key_name                    = var.keypair
    user_data                   = templatefile("./module/haproxy-servers/userdata.sh",{
        master1=var.master1,
        master2=var.master2,
        master3=var.master3
    })

        tags = {
        Name = var.tag1
        }
}

#create haproxy server backup
resource "aws_instance" "haproxy-backup"{
    ami                         = var.ami
    instance_type               = var.instance_type
    subnet_id                   = var.private_subnet2
    vpc_security_group_ids      = [var.haproxy_sg]
    key_name                    = var.keypair
    user_data                   = templatefile("./module/haproxy-servers/userdata2.sh",{
        master1=var.master4,
        master2=var.master5,
        master3=var.master6
})

        tags = {
        Name = var.tag2
        }
}
