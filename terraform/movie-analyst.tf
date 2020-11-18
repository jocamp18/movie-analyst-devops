###################################
###### GENERAL CONFIGURATION ######
###################################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

data "aws_vpc" "ramp-up-vpc" {
  filter {
    name = "tag:Name"
    values = ["ramp_up_training"]
  }
}

###################################
###### MA - UI CONFIGURATION ######
###################################

data "aws_ami" "tf-ui-ami" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values= ["tf-ui-ami"]
  }
}

resource "aws_security_group" "tf-ui-sg" {
  name        = "tf-ui-sg"
  description = "Movie Analyst UI SG - TF"
  vpc_id      = data.aws_vpc.ramp-up-vpc.id

  ingress {
    from_port   = 3030
    to_port     = 3030
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-ui-sg"
    responsible = "Diego.OcampoG"
    project = "ramp-up-devops"
  }
}

resource "aws_lb_target_group" "tf-ui-tg" {
  name     = "tf-ui-tg"
  port     = 3030
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.ramp-up-vpc.id
}

resource "aws_lb" "tf-ui-lb" {
  name               = "tf-ui-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf-ui-sg.id]
  subnets            = ["subnet-0088df5de3a4fe490", "subnet-055c41fce697f9cca"]
  tags = {
    responsible = "Diego.OcampoG"
    project = "ramp-up-devops"
  }
}

resource "aws_lb_listener" "tf-ui-l" {
  load_balancer_arn = aws_lb.tf-ui-lb.arn
  port              = "3030"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-ui-tg.arn
  }
}

resource "aws_launch_template" "tf-ui-t" {
  name          = "tf-ui-t"
  image_id      = data.aws_ami.tf-ui-ami.id
  instance_type = "t2.micro"
  key_name = "ramp-up-devops-jdog"
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.tf-ui-sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      responsible = "Diego.OcampoG"
      project = "ramp-up-devops"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      responsible = "Diego.OcampoG"
      project = "ramp-up-devops"
    }
  }
}

resource "aws_autoscaling_group" "tf-ui-asg" {
  vpc_zone_identifier = ["subnet-0088df5de3a4fe490", "subnet-055c41fce697f9cca"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  target_group_arns  = [aws_lb_target_group.tf-ui-tg.arn]

  launch_template {
    id      = aws_launch_template.tf-ui-t.id
    version = "$Latest"
  }

  tag {
    key = "responsible"
    value = "Diego.OcampoG"
    propagate_at_launch = true
  }

  tag {
    key = "project"
    value = "ramp-up-devops"
    propagate_at_launch = true
  }
}

###################################
###### MA-API  CONFIGURATION ######
###################################

data "aws_ami" "tf-api-ami" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values= ["tf-api-ami"]
  }
}

resource "aws_security_group" "tf-api-sg" {
  name        = "tf-api-sg"
  description = "Movie Analyst API SG - TF"
  vpc_id      = data.aws_vpc.ramp-up-vpc.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tf-api-sg"
    responsible = "Diego.OcampoG"
    project = "ramp-up-devops"
  }
}

resource "aws_lb_target_group" "tf-api-tg" {
  name     = "tf-api-tg"
  port     = 3000
  protocol = "TCP"
  vpc_id   = data.aws_vpc.ramp-up-vpc.id
}

resource "aws_lb" "tf-api-lb" {
  name               = "tf-api-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = ["subnet-0d74b59773148d704", "subnet-038fa9d9a69d6561e"]
  tags = {
    responsible = "Diego.OcampoG"
    project = "ramp-up-devops"
  }
}

resource "aws_lb_listener" "tf-api-l" {
  load_balancer_arn = aws_lb.tf-api-lb.arn
  port              = "3000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-api-tg.arn
  }
}

resource "aws_launch_template" "tf-api-t" {
  name          = "tf-api-t"
  image_id      = data.aws_ami.tf-api-ami.id
  instance_type = "t2.micro"
  key_name = "ramp-up-devops-jdog"
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.tf-api-sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      responsible = "Diego.OcampoG"
      project = "ramp-up-devops"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      responsible = "Diego.OcampoG"
      project = "ramp-up-devops"
    }
  }
}

resource "aws_autoscaling_group" "tf-api-asg" {
  vpc_zone_identifier = ["subnet-0d74b59773148d704", "subnet-038fa9d9a69d6561e"]
  desired_capacity   = 2
  max_size           = 3
  min_size           = 2
  target_group_arns  = [aws_lb_target_group.tf-api-tg.arn]

  launch_template {
    id      = aws_launch_template.tf-api-t.id
    version = "$Latest"
  }

  tag {
    key = "responsible"
    value = "Diego.OcampoG"
    propagate_at_launch = true
  }

  tag {
    key = "project"
    value = "ramp-up-devops"
    propagate_at_launch = true
  }
}
