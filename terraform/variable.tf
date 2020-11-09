variable "ssh_key_public" {
  default     = "/tmp/debian.pub"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}

variable "ssh_key_private" {
  default     = "/tmp/debian"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}

variable "key_pair_name" {
  default     = "debian-key-2"
  description = "AWS SSH Key pair name"
}

variable "aws_region" {
  default     = "eu-west-2"
  description = "AWS region"
}

variable "aws_instance_type" {
  default     = "t2.small"
  description = "EC2 Instance type"
}

variable "ami" {
  default     = "ami-02c4ed7894cd35a3f"
  description = "AWS Image AMI"
}
