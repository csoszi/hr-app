output "vpc_id" {
  value = module.network.vpc_id
}

output "bastion_ip" {
  value = module.bastion.public_ip
}

output "load_balancer_dns" {
  value = module.alb.alb_dns_name
}

output "s3_bucket" {
  value = module.s3.bucket_name
}

output "app_ec2_public_ip" {
  value = aws_instance.hr_app_ec2.public_ip
}

output "app_ec2_private_ip" {
  value = aws_instance.hr_app_ec2.private_ip
}