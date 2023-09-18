

provider "aws" {
  region = "us-east-1"
}

 resource "aws_instance" "demo_server" {
  ami           = "ami-04cb4ca688797756f"
  instance_type = "t2.micro"
  key_name   = "demo_keypair"
  subnet_id = "subnet-0c0e991c01baf8e32"
}

resource "aws_security_group" "demo_sg" {
  name        = "demo_sg"
  description = "SSH"
 # vpc_id      = aws_vpc.main.id

  ingress {
    description      = "SSH access"
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
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}