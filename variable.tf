variable "ssh_key_public" {
  default     = "/tmp/debian.pub"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}

variable "ssh_key_private" {
  default     = "/tmp/debian"
  description = "Path to the SSH public key for accessing cloud instances. Used for creating AWS keypair."
}
