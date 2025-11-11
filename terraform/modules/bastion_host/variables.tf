variable "vpc_id" {
  description = "VPC ID where bastion host will be deployed"
  type        = string
}

variable "public_subnet" {
  description = "Public subnet ID for bastion host"
  type        = string
}

variable "allowed_ip" {
  description = "IPv4 CIDR that can SSH into the bastion host"
  type        = string
}

variable "public_key" {
  description = "SSH public key for bastion"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for bastion"
  type        = string
  default     = "t3.micro"
}
