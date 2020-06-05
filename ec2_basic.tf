provider "aws" {
  region     = "ca-central-1"
}


data "aws_ami" "ubuntu_ec2_ami" {
  most_recent = true
  
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20200408"]
  }
  owners = ["099720109477"]
}

resource "aws_security_group" "allow_ssh_from_terraform" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic, for Anyone: Change cidf block value"

  ingress {
    description = "SSH from Laptop"   
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_from_terraform"
  }
}

resource "aws_instance" "webserver" {
  name = "From terraform"
  ami = aws_ami.ubuntu_ec2_ami.id
  availability_zone = "ca-central-1a"
  instance_type = "t2.micro"  
  key_name = "base_key"
  vpc_security_group_ids = [aws_security_group.allow_ssh_from_terraform.id]
}

output "public_ip" {
  value = "${aws_instance.webserver.public_ip}"
}
