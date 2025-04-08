provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "dock-web" {
  ami = "ami-01f5a0b78d6089704"
  instance_type = "t2.micro"
  key_name = "DevOps-key"

  security_groups = [aws_security_group.docker-webHost_sg.name]

  user_data = <<EOF
  #!/bin/bash
  yum update -y

  # Install Docker
  amazon-linux-extras install docker -y
  systemctl start docker
  systemctl enable docker
  usermod -aG docker ec2-user

  # clone repo
  git clone https://github.com/shiwangbisht/docker-webHosting.git
  cd docker-webHosting

  # build docker image
  docker build -t dock-webHost .

  # Run a container
  docker run -d -p 8080:80 dock-webHost
  EOF



  tags = {
    Name = "docker-webHost"
  }
}

resource "aws_security_group" "docker-webHost_sg" {
  name        = "docker-webHost_sg"
  description = "Allow SSH and Docker access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Change for security reasons
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow our app exposer
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_ec2_instance_state" "stop" {
  instance_id = aws_instance.docker-node-mongo-app.id
  state       = "running"
}

output "public_IP" {
  description = "provide me public_ip"
  value       = aws_instance.dock-web.public_ip
}