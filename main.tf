provider "aws" {
  region     = "us-east-2"
  
}

resource "aws_vpc" "fp-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "fp-vpc"
  }
}


resource "aws_subnet" "fp-public-subnet-1" {
  vpc_id                  = aws_vpc.fp-vpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "fp-public-subnet-1"
  }
}

resource "aws_subnet" "fp-public-subnet-2" {
  vpc_id                  = aws_vpc.fp-vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "fp-public-subnet-2"
  }
}

resource "aws_internet_gateway" "fp-ig" {
  vpc_id = aws_vpc.fp-vpc.id

  tags = {
    Name = "fp-gw"
  }
}

resource "aws_route_table" "fp-rt" {
  vpc_id = aws_vpc.fp-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.fp-ig.id
  }

  tags = {
    Name = "fp-route_table"
  }

}

resource "aws_route_table_association" "to-public-subnet-1" {
  subnet_id      = aws_subnet.fp-public-subnet-1.id
  route_table_id = aws_route_table.fp-rt.id
}

resource "aws_route_table_association" "to-public-subnet-2" {
  subnet_id      = aws_subnet.fp-public-subnet-2.id
  route_table_id = aws_route_table.fp-rt.id
}
