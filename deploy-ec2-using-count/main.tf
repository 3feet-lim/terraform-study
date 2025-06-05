provider "aws" {
  region = var.aws_region  # 서울 리전
}

resource "aws_instance" "web_server" {
  count = 4
  ami = "ami-0c9c942bd7bf113a2"
  instance_type = "t2.micro"
  tags = {
    Name = "Web Server ${count.index}"
  }
}