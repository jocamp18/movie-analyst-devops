variable "ami_id" {
  description = "AMI ID of Amazon Linux 2"
  default     = "ami-000279759c4819ddf"
}

variable "vpc_name" {
  description = "VPC name for ramp-up-devps"
  default     = "ramp_up_training"
}

variable "key_pair" {
  description = "Key pair used for authentication"
  default     = "ramp-up-devops-jdog"
}

variable "fe_port" {
  description = "Port used by frontend"
  default     = "3030"
}

variable "be_port" {
  description = "Port used by Backend"
  default     = "3000"
}

variable "tags" {
  type    = map(string)
  default = {
    responsible: "Diego.OcampoG",
    project: "ramp-up-devops"
  }
}

variable "responsible_tag" {
  description = "Project tag"
  default =  "Diego.OcampoG"
}

variable "project_tag" {
  description = "Project tag"
  default =  "ramp-up-devops"
}

variable "subnet_public0" {
  description = "Subnet public 0"
  default     = "subnet-0088df5de3a4fe490"
}

variable "subnet_public1" {
  description = "Subnet public 1"
  default     = "subnet-055c41fce697f9cca"
}

variable "subnet_private0" {
  description = "Subnet private 0"
  default     = "subnet-0d74b59773148d704"
}

variable "subnet_private1" {
  description = "Subnet prvate 1"
  default     = "subnet-038fa9d9a69d6561e"
}

