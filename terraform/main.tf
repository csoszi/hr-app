# ===== NETWORK MODULE =====
module "network" {
  source    = "./modules/network"
  vpc_cidr  = var.vpc_cidr
  aws_region = var.aws_region
}

# ===== S3 MODULE =====
module "s3" {
  source      = "./modules/s3_bucket"
  bucket_name = var.s3_bucket_name
}

# ===== BASTION HOST MODULE =====
module "bastion" {
  source         = "./modules/bastion_host"
  vpc_id         = module.network.vpc_id
  public_subnet  = module.network.public_subnets[0]
  allowed_ip     = var.allowed_ip
  public_key     = var.public_key
}

# ===== LOAD BALANCER MODULE =====
module "alb" {
  source         = "./modules/load_balancer"
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
}
