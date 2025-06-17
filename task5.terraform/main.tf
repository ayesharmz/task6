terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "random_id" "ayesha_suffix" {
  byte_length = 4
}

resource "aws_security_group" "strapi_sg" {
  name        = "ayesha-strapi-sg-${random_id.ayesha_suffix.hex}"
  description = "Allow port 1337 and SSH access"

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi_ec2" {
  ami           = "ami-0c101f26f147fa7fd"  # Amazon Linux 2023
  instance_type = "t2.micro"

  user_data = file("${path.module}/user-data.sh")

  vpc_security_group_ids = [aws_security_group.strapi_sg.id]

  tags = {
    Name = "StrapiApp"
  }
}
