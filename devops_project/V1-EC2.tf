provider "aws" {
  region = "us-east-1"
}

 resource "aws_instance" "demo_server" {
  ami           = "ami-04cb4ca688797756f"
  instance_type = "t2.micro"
  key_name   = "demo_keypair"
  subnet_id = "subnet-0c0e991c01baf8e32"
}
