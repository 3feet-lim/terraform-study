provider "aws" {
  region = "ap-northeast-2"  # 서울 리전
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c9c942bd7bf113a2"  # Ubuntu 22.04 LTS (서울 리전)
  instance_type = "t2.micro"
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  
  user_data = templatefile("${path.module}/userdata.sh", {
    nickname = "Blessed Dragon"
  })
  
  tags = {
    Name = "WebServer"
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
    Name = "web-server-sg"
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

