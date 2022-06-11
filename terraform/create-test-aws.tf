terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "om-test-terraform-states"
    key    = "om-test-state"
    region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
  #access_key = "AKIAT7EVD2KBERXXXXX"
  #secret_key = "rnucH1/Th8CHKIgPa4W+PCYEEZXXXXXXXXXX"
}

resource "aws_security_group" "om-test-sg" {
  name        = "om-test-sg"
  description = "Traffic 5443 and 22"
  vpc_id      = "vpc-0623cf583004f81f0"


  ingress {
    description = "22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "5443"
    from_port   = 5443
    to_port     = 5443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

}
resource "aws_instance" "for-docker-om-test" {
  ami             = "ami-005de95e8ff495156"
  instance_type   = "t2.medium"
  #instance_type   = "t2.micro"
  key_name        = "mykeypairsergey"
  security_groups = [ "sg-08742a368dd7643f6", "${aws_security_group.om-test-sg.id}" ]
  #vpc_security_group_ids = aws_security_group.om-test-sg.id
  subnet_id       = "subnet-0ee2ec2a28a4e4a0f"
  user_data       = file("inst_docker.sh")
  tags = {
    Name = "for-docker-om-test"
  }

}

output "ec2instance" {
  value = "https://${aws_instance.for-docker-om-test.public_ip}:5443/openmeetings/"
}

# resource "aws_secretsmanager_secret" "hw45-github-token" {
#    name = "github_token"
# }

# variable "GITHUB_TOKEN" {
#     type        = string
# }
# resource "aws_secretsmanager_secret_version" "github_token_ver" {
#   secret_id     = aws_secretsmanager_secret.hw45-github-token.id
#   secret_string = var.GITHUB_TOKEN
# }