provider "aws" {
  region = "us-east-1"
}

 resource "aws_instance" "demo_server" {
  ami           = "ami-04cb4ca688797756f"
  instance_type = "t2.micro"
  key_name   = "demo_keypair"
  //security_groups = [ "demo-sg"]
  vpc_security_group_ids = [aws_security_group.demo_sg.id]
  subnet_id = aws_subnet.dpp-public_subent-01.id

  for_each = toset(["Jenkins-master", "build-slave", "ansible"])
   tags = {
     Name = "${each.key}"
   }
}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "SSH"
  vpc_id      = aws_vpc.dpp-vpc.id

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

// Create VPC
resource "aws_vpc" "dpp-vpc" {
       cidr_block = "10.1.0.0/16"
       tags = {
        Name = "dpp-vpc"
     }
   }


//Create a Subnet 
resource "aws_subnet" "dpp-public_subent-01" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
      Name = "dpp-public_subent-01"
    }
}

resource "aws_subnet" "dpp-public_subent-02" {
    vpc_id = aws_vpc.dpp-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1b"
    tags = {
      Name = "dpp-public_subent-02"
    }
}


//Creating an Internet Gateway 
resource "aws_internet_gateway" "dpp-igw" {
    vpc_id = aws_vpc.dpp-vpc.id
    tags = {
      Name = "dpp-igw"
    }
}

// Create a route table 
resource "aws_route_table" "dpp-public-rt" {
    vpc_id = aws_vpc.dpp-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpp-igw.id
    }
    tags = {
      Name = "dpp-public-rt"
    }
}

// Associate subnet with route table

resource "aws_route_table_association" "dpp-rta-public-subent-01" {
    subnet_id = aws_subnet.dpp-public_subent-01.id
    route_table_id = aws_route_table.dpp-public-rt.id
}

resource "aws_route_table_association" "dpp-rta-public-subent-02" {
    subnet_id = aws_subnet.dpp-public_subent-02.id
    route_table_id = aws_route_table.dpp-public-rt.id
}