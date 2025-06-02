provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
}

# 우분투 버전에 따른 코드네임 매핑
locals {
  ubuntu_codename_map = {
    "18.04" = "bionic"
    "20.04" = "focal"
    "22.04" = "jammy"
    "23.04" = "lunar"
    "23.10" = "mantic"
  }
  ubuntu_codename = lookup(local.ubuntu_codename_map, var.ubuntu_version, "jammy")
}

# 선택한 Ubuntu 버전의 최신 AMI 찾기
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-${local.ubuntu_codename}-${var.ubuntu_version}-*-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = [var.architecture]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

resource "aws_instance" "web_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  user_data = templatefile("${path.module}/userdata.sh", {
    nickname = var.nickname
  })
  
  tags = {
    Name        = "WebServer",
    Environment = "Dev",
    Project     = "TerraformChallenge",
    CreatedBy   = "Terraform"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web_server_sg"
  description = "Security group for web server"
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic on port 8080"
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH traffic"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
  
  tags = {
    Name        = "web-server-sg",
    Environment = "Dev",
    Project     = "TerraformChallenge",
    CreatedBy   = "Terraform"
  }
}

output "web_server_ip" {
  value = aws_instance.web_server.public_ip
  description = "웹 서버의 공용 IP 주소"
}

output "web_url" {
  value = "http://${aws_instance.web_server.public_ip}:8080"
  description = "웹 서버 URL"
}

# 선택된 AMI 정보 출력
output "ami_info" {
  value = {
    id             = data.aws_ami.ubuntu.id
    name           = data.aws_ami.ubuntu.name
    creation_date  = data.aws_ami.ubuntu.creation_date
    architecture   = var.architecture
    ubuntu_version = var.ubuntu_version
  }
  description = "선택된 AMI 정보"
}

