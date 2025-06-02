provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "web" {
  ami           = "ami-0c9c942bd7bf113a2" # Ubuntu 22.04 LTS (ap-northeast-2)
  instance_type = "t2.micro"
  
  # templatefile 함수를 사용하여 userdata.sh 참조
  user_data = templatefile("${path.module}/userdata.sh", {
    nickname = var.nickname
  })
  
  # user_data 변경 시 인스턴스 교체
  user_data_replace_on_change = true
  
  tags = {
    Name = "Terraform-Web-Server"
  }
  
  vpc_security_group_ids = [aws_security_group.web.id]
}

resource "aws_security_group" "web" {
  name        = "web-server-sg"
  description = "Allow HTTP inbound traffic"
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP"
  }
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Custom HTTP port"
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web_server_url" {
  value = "http://${aws_instance.web.public_ip}"
}

output "web_server_url_8080" {
  value = "http://${aws_instance.web.public_ip}:8080"
}

output "nickname" {
  value = var.nickname
}
