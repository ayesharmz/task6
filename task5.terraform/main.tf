provider "aws" {
  region = "us-east-1" # Change if needed
}

resource "aws_security_group" "strapi_sg" {
  name        = "strapi-sg"
  description = "Allow ports for Strapi and SSH"

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
    cidr_blocks = ["0.0.0.0/0"] # Optional, remove this block to disable SSH access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "strapi_ec2" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu 22.04 LTS
  instance_type = "t2.micro"
  security_groups = [aws_security_group.strapi_sg.name]

  # Omit key_name to skip SSH access
  # key_name = "your-key" ← deleted

  user_data = file("${path.module}/user-data.sh") # Your startup script

  tags = {
    Name = "StrapiEC2"
  }
}
