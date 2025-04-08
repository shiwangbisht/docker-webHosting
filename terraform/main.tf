provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "dock-web" {
  ami = ""
  instance_type = ""
  key_name = ""

  security_groups = [aws_security_group.docker-node-mongo-app_sg.name]

  user_data = <<EOF
  #!/bin/bash
  yum update -y

  # Install Docker
  amazon-linux-extras install docker -y
  systemctl start docker
  systemctl enable docker
  usermod -aG docker ec2-user

  git clone 
  cd 



  tags = {
    Name = "docker-node-mongo-app"
  }
}
}