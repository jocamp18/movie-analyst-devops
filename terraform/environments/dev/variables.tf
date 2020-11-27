variable "ami_id_fe" {
  description = "AMI ID of frontend"
  default     = "ami-000279759c4819ddf"
}

variable "ami_id_be" {
  description = "AMI ID of backend"
  default     = "ami-000279759c4819ddf"
}

variable "instance_type_fe" {
  description = "Instance used by frontend"
  default     = "t2.micro"
}

variable "instance_type_be" {
  description = "Instance used by backend"
  default     = "t2.micro"
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

variable "public_subnets" {
  description = "Public subnets"
  default     = ["subnet-0088df5de3a4fe490", "subnet-055c41fce697f9cca"]
}

variable "private_subnets" {
  description = "Private subnets"
  default     = ["subnet-0d74b59773148d704", "subnet-038fa9d9a69d6561e"]
}

