data "aws_vpc" "ramp-up-vpc" {
  filter {
    name = "tag:Name"
    values = [var.vpc_name]
  }
}

