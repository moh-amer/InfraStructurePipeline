output "vpc_id" {
  value = aws_vpc.vpctf.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpctf.cidr_block

}

output "public_subnet01_id" {
  value = aws_subnet.public_subnet01.id
}

output "public_subnet02_id" {
  value = aws_subnet.public_subnet02.id
}

output "private_subnet01_id" {
  value = aws_subnet.private_subnet01.id
}

output "private_subnet02_id" {
  value = aws_subnet.private_subnet02.id
}
