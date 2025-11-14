# ===== NETWORK MODULE =====
module "network" {
  source     = "./modules/network"
  vpc_cidr   = var.vpc_cidr
  aws_region = var.aws_region
}

# ===== S3 MODULE =====
module "s3" {
  source      = "./modules/s3_bucket"
  bucket_name = var.s3_bucket_name
}

# ===== BASTION HOST MODULE =====
module "bastion" {
  source        = "./modules/bastion_host"
  vpc_id        = module.network.vpc_id
  public_subnet = module.network.public_subnets[0]
  allowed_ip    = var.allowed_ip
  public_key    = var.public_key
}

# ===== LOAD BALANCER MODULE =====
module "alb" {
  source         = "./modules/load_balancer"
  vpc_id         = module.network.vpc_id
  public_subnets = module.network.public_subnets
}

# ===== EC2 INSTANCE (App Server with Docker) =====
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

# Use cloud-init template to install Docker and run container
data "template_file" "cloudinit" {
  template = file("${path.module}/cloudinit/docker_run.yml")
  vars = {
    dockerhub_user = var.dockerhub_user
  }
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloudinit.rendered
  }
}

# ===== SECURITY GROUP FOR APP =====
resource "aws_security_group" "app_ec2_sg" {
  name        = "hr-app-ec2-sg"
  description = "Allow HTTP + SSH from Bastion"
  vpc_id      = module.network.vpc_id

  # Allow HTTP from everywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH ONLY from Bastion Host SG
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [module.bastion.bastion_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hr-app-ec2-sg"
  }
}

# ===== KEY PAIR =====
resource "aws_key_pair" "my_key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}

# ===== EC2 INSTANCE =====
resource "aws_instance" "hr_app_ec2" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = module.network.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.app_ec2_sg.id]
  key_name               = aws_key_pair.my_key.key_name
  user_data              = data.template_cloudinit_config.config.rendered

  tags = {
    Name = "hr-app-docker-instance"
  }
}