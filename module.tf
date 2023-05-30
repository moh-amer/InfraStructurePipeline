module "mynetwork" {
  source       = "./network"
  cidr_block   = var.cidr_block
  subnet_cidrs = var.subnet_cidrs
}
