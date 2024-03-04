#vpc

resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block_vpc  #CIDR range for the vpc
  instance_tenancy = "default"   # Make sure your instances on the host.
  enable_dns_support = true      # Requied for EKS. Enable/Disable DNS support in the vpc
  enable_dns_hostnames = true    # Requied for EKS. Enable/Disable DNS support in the vpc

  tags = {
    Name = "main"
  }
}

#Subnets

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public1_cidr  # CIDR range of the subnet
  availability_zone = var.avai-zone-1
  map_public_ip_on_launch = true #(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false.

  tags = {
    Name = "public-us-east-2a"
    "kubernetes.io/cluster/eks" = "shared" #It allows a eks cluster to discover the paricular subnet and us it
    "kubernetes.io/cluster/eks" = 1  # Incase if you want to deploy public load balancer and when u create a k8s servie type load balancer
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public2_cidr  # CIDR range of the subnet
  availability_zone = var.avai-zone-2
  map_public_ip_on_launch = true #(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address. Default is false.

  tags = {
    Name = "public-us-east-2b"
    "kubernetes.io/cluster/eks" = "shared" 
    "kubernetes.io/cluster/eks" = 1  
  }
}

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private1_subnet_cidr  # CIDR range of the subnet
  availability_zone = var.avai-zone-1
  tags = {
    Name = "private-us-east-2a"
    "kubernetes.io/cluster/eks" = "shared" 
    "kubernetes.io/role/internal-elb" = 1  # This internal elb allows a eks cluster to deploy a private laod balancerin this subnet
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private2_subnet_cidr  # CIDR range of the subnet
  availability_zone = var.avai-zone-2
  tags = {
    Name = "private-us-east-2b"
    "kubernetes.io/cluster/eks" = "shared" 
    "kubernetes.io/role/internal-elb" = 1  # This internal elb allows a eks cluster to deploy a private laod balancerin this subnet
  }
}



#IGW
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

#elatic ip's
resource "aws_eip" "nat-1" {
 
  depends_on = [aws_internet_gateway.main]

}

resource "aws_eip" "nat-2" {
  # EIP may require IGW to exist prior to association.associate_with_private_ip
  # Use depends_on to set an explicit dependency on the IGW.associate_with_private_ip
  depends_on = [aws_internet_gateway.main]
}


#NAT 

resource "aws_nat_gateway" "gw1" {
  allocation_id = aws_eip.nat-1.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "NAT-1"
  }
}

resource "aws_nat_gateway" "gw2" {
  allocation_id = aws_eip.nat-2.id
  subnet_id     = aws_subnet.public-2.id

  tags = {
    Name = "NAT-2"
  }
}

#Route-table 

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  #CIDR block of the route

    # Identifier of a VPC internet gateway or a virtual private gateway.
    gateway_id = aws_internet_gateway.main.id
  }

  /*route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_internet_gateway.main.id
  }  */

  tags = {
    Name = "public"
  }

}

resource "aws_route_table" "private-1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  #CIDR block of the route

    # Identifier of a VPC internet gateway or a virtual private gateway.
    nat_gateway_id = aws_nat_gateway.gw1.id
  }

  tags = {
    Name = "private-1"
  }
  
}


resource "aws_route_table" "private-2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"  #CIDR block of the route

    # Identifier of a VPC internet gateway or a virtual private gateway.
    nat_gateway_id = aws_nat_gateway.gw2.id
  }

  tags = {
    Name = "private-2"
  }
  
}

#Route-table-association

resource "aws_route_table_association" "public-1" {
  subnet_id      = aws_subnet.public-1.id  # The subnet ID to create an association
  route_table_id = aws_route_table.public.id  # The ID of the routing table to associating with.
}

resource "aws_route_table_association" "public-2" {
  subnet_id      = aws_subnet.public-2.id  # The subnet ID to create an association
  route_table_id = aws_route_table.public.id  # The ID of the routing table to associating with.
}

resource "aws_route_table_association" "private-1" {
  subnet_id      = aws_subnet.private-1.id  # The subnet ID to create an association
  route_table_id = aws_route_table.private-1.id  # The ID of the routing table to associating with.
}

resource "aws_route_table_association" "private-2" {
  subnet_id      = aws_subnet.private-2.id  # The subnet ID to create an association
  route_table_id = aws_route_table.private-2.id  # The ID of the routing table to associating with.
}

