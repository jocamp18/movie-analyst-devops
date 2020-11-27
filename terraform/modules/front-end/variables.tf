variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "fe_port" {
  type        = string
  description = "Port used by frontend"
  default     = "3030"
}

variable "subnets"{
  type        = list(string)
  description = "Subnets of Webservers"
}

variable "elb_subnets"{
  type        = list(string)
  description = "Subnets of ELB"
}

variable "ami_id" {
  type        = string
  description = "AMI ID"
}

variable "instance_type" {
  type        = string
  description = "Instance type"
}

variable "tags" {
  type        = map(string)
  description = "Tags used in training"
}

variable "key_pair" {
  type        = string
  description = "SSH key"
}

variable "responsible_tag" {
  type        = string
  description = "Responsible tag"
}

variable "project_tag" {
  type        = string
  description = "Project tag"
}
