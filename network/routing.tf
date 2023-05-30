# PUBLIC ROUTING TABLE
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpctf.id

  tags = {
    Name = "PUBLIC_ROUTE_TABLE"
  }
}

resource "aws_route" "pub_route" {
  route_table_id         = aws_route_table.public_route_table.id
  gateway_id             = aws_internet_gateway.main_gw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "associate_public_subnet01" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet01.id
}

resource "aws_route_table_association" "associate_public_subnet02" {
  route_table_id = aws_route_table.public_route_table.id
  subnet_id      = aws_subnet.public_subnet02.id
}


#PRIVATE ROUTING
resource "aws_route_table" "private_route_talbe" {
  vpc_id = aws_vpc.vpctf.id
  tags = {
    "Name" = "PRIVATE_ROUTE_TABLE"
  }
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_talbe.id
  nat_gateway_id         = aws_nat_gateway.mynat.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "associate_private_subnet01" {
  route_table_id = aws_route_table.private_route_talbe.id
  subnet_id      = aws_subnet.private_subnet01.id
}

resource "aws_route_table_association" "associate_private_subnet02" {
  route_table_id = aws_route_table.private_route_talbe.id
  subnet_id      = aws_subnet.private_subnet02.id
}
