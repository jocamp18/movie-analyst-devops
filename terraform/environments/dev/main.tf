data "aws_vpc" "ramp-up-vpc" {
  filter {
    name = "tag:Name"
    values = [var.vpc_name]
  }
}

module "frontend" {
  source          = "../../modules/front-end"
  vpc_id          = data.aws_vpc.ramp-up-vpc.id
  subnets         = var.private_subnets
  elb_subnets     = var.public_subnets
  ami_id          = var.ami_id_fe
  instance_type   = var.instance_type_fe
  key_pair        = var.key_pair
  tags            = var.tags
  responsible_tag = "Diego.OcampoG"
  project_tag     = "ramp-up-devops"
}

module "backend" {
  source          = "../../modules/back-end"
  vpc_id          = data.aws_vpc.ramp-up-vpc.id
  subnets         = var.private_subnets
  ami_id          = var.ami_id_be
  instance_type   = var.instance_type_be
  key_pair        = var.key_pair
  tags            = var.tags
  responsible_tag = "Diego.OcampoG"
  project_tag     = "ramp-up-devops"
}

module "bastion" {
  source        = "../../modules/bastion"
  ami_id        = var.ami_id_fe
  vpc_id        = data.aws_vpc.ramp-up-vpc.id
  instance_type = var.instance_type_fe
  key_pair      = var.key_pair
  tags          = var.tags
  subnet_id     = "subnet-0088df5de3a4fe490"
}
