# Dependencies For RDS :
resource "aws_db_subnet_group" "db_subnet_gp" {
  name       = "mysqlsubnetgp"
  subnet_ids = [module.mynetwork.private_subnet01_id, module.mynetwork.private_subnet02_id]
  tags = {
    Name = "MySQL DB subnet group"
  }
}

data "aws_secretsmanager_secret" "by-arn" {
  arn = var.secret_arn
}

data "aws_secretsmanager_secret_version" "secret-version" {
  secret_id = data.aws_secretsmanager_secret.by-arn.id
}


resource "aws_kms_key" "db_key" {
  description = "KMS key for managing my database password"
}

#RDS Provisioning
resource "aws_db_instance" "myrds_mysql" {
  allocated_storage      = 10
  db_name                = "iti_db"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["username"]
  password               = jsondecode(data.aws_secretsmanager_secret_version.secret-version.secret_string)["password"]
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_gp.name
  vpc_security_group_ids = [aws_security_group.mysql_db_security_gp.id]
  port                   = var.mysql_port

}


###################################################
#Dependencies for Elastic Cache:
resource "aws_elasticache_subnet_group" "cache_subnet_gp" {
  name       = "tf-cache-subnet"
  subnet_ids = [module.mynetwork.private_subnet01_id, module.mynetwork.private_subnet02_id]
}

#ELASTIC CACHE CLUSTER PROVISIONING
resource "aws_elasticache_cluster" "myelastic_cache_redis" {
  cluster_id           = "cluster-terraform"
  engine               = "redis"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = var.redis_port
  subnet_group_name    = aws_elasticache_subnet_group.cache_subnet_gp.name
  security_group_ids   = [aws_security_group.elastic_cache_security_gp.id]
}
