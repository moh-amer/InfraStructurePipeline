data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "public_subnet01" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[0]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    "Name" = "public-subnet01"
  }
}

resource "aws_subnet" "public_subnet02" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[1]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    "Name" = "public-subnet02"
  }

}

resource "aws_subnet" "private_subnet01" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[2]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    "Name" = "private-subnet01"
  }
}

resource "aws_subnet" "private_subnet02" {
  vpc_id            = aws_vpc.vpctf.id
  cidr_block        = var.subnet_cidrs[3]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    "Name" = "private-subnet02"
  }
}
