#VPC
resource "aws_vpc" "vpctf" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    "Name" = "VPC_TERRAFORM"
  }
}


#INTERNET GATEWAY
resource "aws_internet_gateway" "main_gw" {
  vpc_id = aws_vpc.vpctf.id

  tags = {
    Name = "TERRAFORM_GATEWAY"
  }
}

#ELASTIC IP
resource "aws_eip" "nat_elip" {
}

#NAT GATEWAY
resource "aws_nat_gateway" "mynat" {
  #   association_id = aws_eip.nat_elip.id
  allocation_id = aws_eip.nat_elip.id
  subnet_id     = aws_subnet.public_subnet01.id

  tags = {
    Name = "TERRAFORM NAT"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  #   depends_on = [aws_internet_gateway.main_gw]
}
