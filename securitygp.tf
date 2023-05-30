resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.mynetwork.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_ssh_port_3000_cidr" {
  name        = "allow_ssh_and_port_3000"
  description = "Allow SSH and port 3000 inbound traffic"
  vpc_id      = module.mynetwork.vpc_id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [module.mynetwork.vpc_cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  ingress {
    description = "Open port 3000 for tcp"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [module.mynetwork.vpc_cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_tcp_3000"
  }
}

resource "aws_security_group" "mysql_db_security_gp" {
  name        = "mysql_database_security_group"
  description = "Allow Traffic on port 3306 inbound traffic"
  vpc_id      = module.mynetwork.vpc_id

  ingress {
    description = "mysql port allow"
    from_port   = var.mysql_port
    to_port     = var.mysql_port
    protocol    = "tcp"
    cidr_blocks = [module.mynetwork.vpc_cidr_block]
    # ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tcp_3306"
  }
}

resource "aws_security_group" "elastic_cache_security_gp" {
  name        = "elastic_cache_security_group"
  description = "Allow Traffic on port 6379 inbound traffic"
  vpc_id      = module.mynetwork.vpc_id

  ingress {
    description = "elastic_cache port allow"
    from_port   = var.redis_port
    to_port     = var.redis_port
    protocol    = "tcp"
    cidr_blocks = [module.mynetwork.vpc_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tcp_6379"
  }
}
