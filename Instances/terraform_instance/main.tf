terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.13.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amzn-linux-2023-ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

resource "aws_instance" "tf_ec2" {
  ami                    = data.aws_ami.amzn-linux-2023-ami.id # var.ec2_ami
  instance_type          = var.ec2_type
  key_name               = "first-key-pair"
  vpc_security_group_ids = [aws_security_group.tf-sec-gr.id]
  #   vpc_security_group_ids = [
  #     "sg-02cc1ba79640d614f"
  #   ]
  user_data = file("${path.module}/script.sh")
  tags = {
    Name = "${var.ec2_name}-instance"
  }
}

resource "aws_security_group" "tf-sec-gr" {
  name        = "tf-sec-gr"
  description = "Allow SSH inbound traffic"

  ingress {
    description      = "SSH inbound traffic"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SSH_inbound"
  }
}

output "tf_example_public_ip" {
  value = aws_instance.tf_ec2.public_ip
}

output "tf_example_private_ip" {
  value = aws_instance.tf_ec2.private_ip
}
