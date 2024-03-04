
#vpc 

variable "cidr_block_vpc" {
  type = string
  default = "192.168.0.0/16"
}

#subnet public - 1
variable "public1_cidr" {
  type = string
  default = "192.168.72.0/18"
}

variable "avai-zone-1" {
  type = string
  default = "us-east-2a"          #availability zone 1
}

#subnet public-2

variable "public2_cidr" {
  type = string
  default = "192.168.64.0/18"
}

variable "avai-zone-2" {    #avaiability zone 2
  type = string
  default = "us-east-2b"
}

#subnet private-1

variable "private1_subnet_cidr" {
  type = string
  default = "192.168.128.0/18"
}

variable "private2_subnet_cidr" {
  type = string
  default = "192.168.192.0/18"
}

#node-group

variable "iam-role-name" {
  type = string
  default = "eks-node-group-general"
}

variable "eks-node-group-name" {
  type = string
  default = "nodes-general"   # Name of the EKS Node Group.
}
  
variable "desired-size" {   # Desired number of worker nodes.
  type = number
  default = 1
}

variable "max-size" {       # Maximum number of worker nodes.
  type = number
  default = 1
}

variable "min-size" {       # Minimum number of worker nodes.
  type = number
  default = 1
}

variable "ami-type" {       # Minimum number of worker nodes.
  type = string
  default = "AL2_x86_64"
}

variable "capacity-type" {       # Minimum number of worker nodes.
  type = string
  default = "ON_DEMAND"
}

variable "disk-size" {       # Minimum number of worker nodes.
  type = number
  default = 20
}

variable "kubernetes-version" {       # Minimum number of worker nodes.
  type = string
  default = "1.25"
}

#EKS

variable "iam-role-name-eks-cluster" {      
  type = string
  default = "eks-cluster"
}

variable "eks-name" {       
  type = string                 #Name of the eks cluster
  default = "eks"
}










