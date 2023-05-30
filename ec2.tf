resource "tls_private_key" "terrafrom_generated_private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {

  # Name of key : Write the custom name of your key
  key_name = "aws_keys_pairs"

  # Public Key: The public will be generated using the reference of tls_private_key.terrafrom_generated_private_key
  public_key = tls_private_key.terrafrom_generated_private_key.public_key_openssh

  # Store private key :  Generate and save private key(aws_keys_pairs.pem) in current directory
  provisioner "local-exec" {
    command = <<-EOT
      echo '${tls_private_key.terrafrom_generated_private_key.private_key_pem}' > aws_keys_pairs.pem
      chmod 400 aws_keys_pairs.pem
    EOT
  }
}


locals {
  private_key_base64 = base64encode(tls_private_key.terrafrom_generated_private_key.private_key_pem)
}

resource "aws_instance" "bastion_ec2" {
  ami                         = var.ami_id
  instance_type               = var.ec2_type
  security_groups             = [aws_security_group.allow_ssh.id]
  associate_public_ip_address = true
  subnet_id                   = module.mynetwork.public_subnet01_id

  tags = {
    Name = "Bastion Instance"
  }

  key_name = var.key_pair_name

  user_data = <<-EOF
              #!/bin/bash
              echo '${local.private_key_base64}' | base64 -d > /home/ec2-user/key.pem
              sudo yum install -y gcc
              wget http://download.redis.io/redis-stable.tar.gz && tar xvzf redis-stable.tar.gz && cd redis-stable && make
              sudo cp src/redis-cli /usr/bin/
              sudo yum install -y https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm
              sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022
              sudo yum install -y mysql
              EOF
}


resource "aws_instance" "app_instance" {
  ami             = var.ami_id
  instance_type   = var.ec2_type
  security_groups = [aws_security_group.allow_ssh_port_3000_cidr.id]
  subnet_id       = module.mynetwork.private_subnet01_id
  key_name        = var.key_pair_name

  tags = {
    Name = "Application Instance"
  }

}

resource "null_resource" "local_prov" {
  depends_on = [
    aws_instance.bastion_ec2
  ]

  provisioner "local-exec" {
    command = <<-EOT
    echo "${aws_instance.bastion_ec2.public_ip}" > inventory
    EOT
  }
}
