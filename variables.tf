#variables for the provider block
variable aws_region {
  type        = string
  description = "region for the vpc"
  default     = "ap-south-1"
}

#variables for the resource block
#1-vpc cidr block
variable cidr_vpc {
  type        = string
  description = "vpc cidr"
  default     = "10.0.0.0/16" # 65536 ip opened
}

#2-subnet-public-1 cidr block
variable pubsub1 {
  type        = string
  description = "public subnet 1 cidr"
  default     = "10.0.1.0/24" # 256 ip opened
}

#3-subnet-public-2 cidr block
variable pubsub2 {
  type        = string
  description = "public subnet 2 cidr"
  default     = "10.0.2.0/24" # 256 ip opened
}

#4-subnet-private-1 cidr block
variable pvtsub1 {
  type        = string
  description = "private subnet 1 cidr"
  default     = "10.0.3.0/24" # 256 ip opened
}

#5-subnet-private-2 cidr block
variable pvtsub2 {
  type        = string
  description = "private subnet 2 cidr"
  default     = "10.0.4.0/24" # 256 ip opened
}

#6-subnet-public-1 availability zone
variable az_sub_pub1 {
  type        = string
  description = "public subnet 1 availability zone"
  default     = "ap-south-1a" 
}

#7-subnet-public-2 availability zone
variable az_sub_pub2 {
  type        = string
  description = "public subnet 2 availability zone"
  default     = "ap-south-1b" 
}

#8-subnet-private-1 availability zone
variable az_sub_pvt1 {
  type        = string
  description = "private subnet 1 availability zone"
  default     = "ap-south-1a" 
}

#9-subnet-private-2 availability zone
variable az_sub_pvt2 {
  type        = string
  description = "private subnet 2 availability zone"
  default     = "ap-south-1b" 
}

#10-ami id for the instance public1,2 
variable ami_id {
  type        = string
  description = "ami id for the public server1&2"
  default     = "ami-079b5e5b3971bd10d" 
}

#11-instance type for the instance public1,2 
variable instance_type {
  type        = string
  description = "instancetype for the public server1&2"
  default     = "t2.micro" 
}

#12-username for the Database 
variable db_username {
  type        = string
  description = "username for database"
  default     = "admin" 
}

#13-password for the Database 
variable db_password {
  type        = string
  description = "password for database"
  default     = "admin123" 
}

#14-availability zone for the Database 
variable rds_availability_zone {
  type        = string
  description = "availability zone-rds"
  default     = "ap-south-1a" 
}