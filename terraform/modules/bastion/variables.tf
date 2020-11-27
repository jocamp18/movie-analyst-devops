variable "ami_id" {
  type        = string
  description = "AMI of bastion"
}

variable "vpc_id" {
  type        = string
  description = "VPC of bastion"
}

variable "instance_type" {
  type        = string
  description = "Instance type of bastion"
}

variable "tags" {
  type        = map(string)
  description = "Tags for training"
}

variable "key_pair" {
  type        = string
  description = "SSH key access"
}

variable "subnet_id" {
  type        = string
  description = "Public subnet for bastion"
}
