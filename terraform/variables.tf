variable "allowed_ip" {
  description = "IPv4 CIDR allowed to SSH into bastion"
  type        = string
}

variable "public_key" {
  description = "SSH public key for bastion host"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "s3_bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "hr-app-data-kd" 
}

variable "aws_profile" {
  description = "AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "dockerhub_user" {
  description = "Your Docker Hub username"
  type        = string
}

variable "docker_image_name" {
  description = "Docker image name (e.g. hr-app:latest)"
  type        = string
}

