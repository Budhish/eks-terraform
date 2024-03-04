

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block_vpc  #CIDR range for the vpc
  instance_tenancy = "default"   # Make sure your instances on the host.
  enable_dns_support = true      # Requied for EKS. Enable/Disable DNS support in the vpc
  enable_dns_hostnames = true    # Requied for EKS. Enable/Disable DNS support in the vpc

  tags = {
    Name = "main"
  }
}


output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "aws_internet_gateway" {
  description = "The ID of the IGW"
  value       = aws_internet_gateway.main.id
}

output "aws_subnet-public-1" {
  description = "The ID of the public subnet-1"
  value       = aws_subnet.public-1.id
}

output "aws_subnet-public-2" {
  description = "The ID of the public subnet-2"
  value       = aws_subnet.public-2.id
}

output "aws_subnet-private-1" {
  description = "The ID of the public subnet-1"
  value       = aws_subnet.private-1.id
}

output "aws_subnet-private-2" {
  description = "The ID of the public subnet-1"
  value       = aws_subnet.private-2.id
}
