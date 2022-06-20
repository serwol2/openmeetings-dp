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
  region = "us-east-1" # del for pipeline
  #access_key = "AKIAT7EVD2KBERXXXXX"
  #secret_key = "rnucH1/Th8CHKIgPa4W+PCYEEZXXXXXXXXXX"
}

########################################## create ec2 with kurento docker ###########################################
resource "aws_security_group" "om-test-sg-kms" {       # 2 вообще всю работу с secority group заменить на модуль
  name        = "om-test-sg-kms"
  description = "22, 8888"
  vpc_id      = "vpc-0623cf583004f81f0"   # 2 этот хардкод потом заменить 

  ingress {
    description = "22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "8888"
    from_port   = 8888
    to_port     = 8888
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
resource "aws_instance" "for-curento-om-test" {   # убрать нафиг потом паблик ip и поубирать хардкоды
  ami             = "ami-0c4f7023847b90238"
  instance_type   = "t2.micro"
  key_name        = "mykeypairsergey"
  #associate_public_ip_address = false
  vpc_security_group_ids = [ "sg-08742a368dd7643f6", "${aws_security_group.om-test-sg-kms.id}" ]
  #vpc_security_group_ids = aws_security_group.om-test-sg.id
  subnet_id       = "subnet-0ee2ec2a28a4e4a0f"
  user_data       = <<EOF
#!/bin/bash
sudo apt update && sudo apt install -y docker.io
sudo docker run -d --name kms -p 8888:8888 kurento/kurento-media-server:latest
EOF
  tags = {
    Name = "for-curento-om-test"
  }

}
########################################## create ec2 with kurento docker ###########################################


########################################## create ec2 with test-om docker ###########################################
resource "aws_security_group" "om-test-sg" {       # вообще всю работу с secority group заменить на модуль
  name        = "om-test-sg"
  description = "Traffic 5443 and 22"
  vpc_id      = "vpc-0623cf583004f81f0"   # этот хардкод потом заменить 
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
  vpc_security_group_ids = [ "sg-08742a368dd7643f6", "${aws_security_group.om-test-sg.id}" ]
  subnet_id       = "subnet-0ee2ec2a28a4e4a0f"   # этот хардкод заменить
  #user_data       = file("inst_docker.sh")
  user_data = <<EOF
#!/bin/bash
sudo apt update && sudo apt install docker.io -y
sudo docker run -d --name om-test -p 5443:5443 \
  -e OM_TYPE="min" \
  -e OM_KURENTO_WS_URL="ws://${aws_instance.for-curento-om-test.private_ip}:8888/kurento" \
  -it ghcr.io/serwol2/openmeetings-dp:develop
EOF
  tags = {
    Name = "for-docker-om-test"
  }

}
########################################## create ec2 with test-om docker ###########################################



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