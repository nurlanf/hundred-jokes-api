terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

resource "aws_key_pair" "debian" {
  key_name   = "debian-key"
  public_key = file("/tmp/debian.pub")
}

# Create a instance
resource "aws_instance" "app" {
  key_name = aws_key_pair.debian.key_name
  ami           = "ami-02c4ed7894cd35a3f"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]

  connection {
    host        = self.public_ip
    type        = "ssh"
    user        = "admin"
    private_key = file(var.ssh_key_private)
  }

  provisioner "file" {
    source      = "../files/"
    destination = "/home/admin"

  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt -y update && sudo apt install python3-pip -y",
      "sudo pip3 install ansible",
      "ansible-galaxy collection install community.docker",
      "ansible-playbook -i localhost /home/admin/ansible/playbook.yaml"
      ]
  }

}

# Create a loadbalancer
resource "aws_eip" "jokes-lb" {
  instance = aws_instance.app.id
  vpc      = true
}
