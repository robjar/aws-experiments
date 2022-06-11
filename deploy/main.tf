provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my-first-server" {
  ami           = "ami-0747bdcabd34c712a"
  instance_type = "t2.micro"

  tags = {
    Name = "ubuntu"
  }
}
