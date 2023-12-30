#VPC
resource "aws_vpc" "myvpc" {
  cidr_block       = var.cidr_vpc
  instance_tenancy = "default"

  tags = {
    Name = "project-vpc"
  }
}

#IGW
resource "aws_internet_gateway" "myigw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "project-igw"
  }
}

#SUBNET-PUBLIC
#public subnet-1
resource "aws_subnet" "pubsub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.pubsub1
  availability_zone = var.az_sub_pub1

  tags = {
    Name = "public-subnet-1"
  }
}
#public subnet-2
resource "aws_subnet" "pubsub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.pubsub2
  availability_zone = var.az_sub_pub2

  tags = {
    Name = "public-subnet-2"
  }
}

#SUBNET-PRIVATE
#privte subnet-1
resource "aws_subnet" "pvtsub1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.pvtsub1
  availability_zone = var.az_sub_pvt1

  tags = {
    Name = "private-subnet-1"
  }
}
#privte subnet-2
resource "aws_subnet" "pvtsub2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.pvtsub2
  availability_zone = var.az_sub_pvt2

  tags = {
    Name = "private-subnet-2"
  }
}

#ROUTE TABLE-PUBLIC
#Public Route-table-1
resource "aws_route_table" "pubrt1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "public-rt-1"
  }
}
#Public Route-table-2
resource "aws_route_table" "pubrt2" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myigw.id
  }

  tags = {
    Name = "public-rt-2"
  }
}

#ROUTE TABLE-PRIVATE
#private Route-table-1
resource "aws_route_table" "pvtrt1" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pvtnat1.id
  }

  tags = {
    Name = "private-rt-1"
  }
}
#private Route-table-2
resource "aws_route_table" "pvtrt2" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.pvtnat2.id
  }

  tags = {
    Name = "private-rt-2"
  }
}

#ELASTIC IP 
#EIP-1
resource "aws_eip" "eip1" {
 vpc = true
}
#EIP-2
resource "aws_eip" "eip2" {
 vpc = true
}

#NAT GATEWAY-1
resource "aws_nat_gateway" "pvtnat1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.pubsub1.id

  tags = {
    Name = "PVT-NAT-GW-1"
  }
}
#NAT GATEWAY-2
resource "aws_nat_gateway" "pvtnat2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.pubsub2.id

  tags = {
    Name = "PVT-NAT-GW-2"
  }
}

#ROUTE TABLE-ASSOSCIATION -PUBLIC 
#RT-ASS-PUB1
resource "aws_route_table_association" "pubassoc1" {
  subnet_id      = aws_subnet.pubsub1.id
  route_table_id = aws_route_table.pubrt1.id
}
#RT-ASS-PUB2
resource "aws_route_table_association" "pubassoc2" {
  subnet_id      = aws_subnet.pubsub2.id
  route_table_id = aws_route_table.pubrt2.id
}

#ROUTE TABLE-ASSOSCIATION -PRIVATE
#RT-ASS-PVT1
resource "aws_route_table_association" "pvtassoc1" {
  subnet_id      = aws_subnet.pvtsub1.id
  route_table_id = aws_route_table.pvtrt1.id
}
#RT-ASS-PVT2
resource "aws_route_table_association" "pvtassoc2" {
  subnet_id      = aws_subnet.pvtsub2.id
  route_table_id = aws_route_table.pvtrt2.id
}

#SECURITY GROUP PUBLIC  
resource "aws_security_group" "pub-seg" {
  name        = "pub-seg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "PUB-SEG"
  }
}
#SECURITY GROUP PRIVATE
resource "aws_security_group" "pvt-seg" {
  name        = "pvt-seg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups =  [aws_security_group.pub-seg.id]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    security_groups =  [aws_security_group.pub-seg.id]
  }
  ingress {
    description      = "mysql"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    security_groups =  [aws_security_group.pub-seg.id]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups =  [aws_security_group.pub-seg.id]
  }

  tags = {
    Name = "PUB-SEG"
  }
}