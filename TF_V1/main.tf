terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
  }

data "aws_ssm_parameter" "ami" {
 name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
  

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = "true"

  
}

resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.vpc.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
}

resource "aws_instance" "web" {
  ami           = nonsensitive(data.aws_ssm_parameter.ami.value)
  instance_type = "t2.micro"
  tags = {
    Name = "HelloWorld"
  }
}

connection {
  type        = "ssh"
  host        = "self.public_ip
  user        = "ec2-user"
  private_key = file(var.private_key_path)
  
  }
  

  
