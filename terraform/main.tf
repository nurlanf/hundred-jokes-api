terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_key_pair" "debian" {
  key_name   = var.key_pair_name
  public_key = file(var.ssh_key_public)
}

# Create a instance
resource "aws_instance" "app" {
  key_name = aws_key_pair.debian.key_name
  ami           = var.ami
  instance_type = var.aws_instance_type
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "admin"
    private_key = file(var.ssh_key_private)
  }

  provisioner "file" {
    source      = "../ansible"
    destination = "/home/admin"
  }

  provisioner "remote-exec" {
    inline = [
      # Install ansible related packages
      "sudo apt -y update && sudo apt install python3-pip -y",
      "sudo pip3 install ansible",
      # Run ansible playbook
      "ansible-playbook -i localhost /home/admin/ansible/playbook.yaml"
      ]
  }

}

# Create a loadbalancer
resource "aws_eip" "jokes-lb" {
  instance = aws_instance.app.id
  vpc      = true
}
