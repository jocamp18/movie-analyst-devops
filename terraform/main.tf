###################################
###### MA - UI CONFIGURATION ######
###################################

resource "aws_security_group" "tf-ui-sg" {
  name        = "tf-ui-sg"
  description = "Movie Analyst UI SG - TF"
  vpc_id      = data.aws_vpc.ramp-up-vpc.id

  ingress {
    from_port   = var.fe_port
    to_port     = var.fe_port
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
    responsible = var.responsible_tag
    project = var.project_tag
  }
}

resource "aws_lb_target_group" "tf-ui-tg" {
  name     = "tf-ui-tg"
  port     = var.fe_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.ramp-up-vpc.id
}

resource "aws_lb" "tf-ui-lb" {
  name               = "tf-ui-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf-ui-sg.id]
  subnets            = [var.subnet_public0, var.subnet_public1]
  tags = {
    responsible = var.responsible_tag
    project = var.project_tag
  }
}

resource "aws_lb_listener" "tf-ui-l" {
  load_balancer_arn = aws_lb.tf-ui-lb.arn
  port              = var.fe_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-ui-tg.arn
  }
}

resource "aws_launch_template" "tf-ui-t" {
  name          = "tf-ui-t"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name = var.key_pair
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.tf-ui-sg.id]
  }

  user_data = filebase64("${path.module}/scripts/fe-bootstrap.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      responsible = var.responsible_tag
      project = var.project_tag
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      responsible = var.responsible_tag
      project = var.project_tag
    }
  }
}

resource "aws_autoscaling_group" "tf-ui-asg" {
  vpc_zone_identifier = [var.subnet_public0, var.subnet_public1]
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
    value = var.responsible_tag
    propagate_at_launch = true
  }

  tag {
    key = "project"
    value = var.project_tag
    propagate_at_launch = true
  }
}

###################################
###### MA-API  CONFIGURATION ######
###################################

resource "aws_security_group" "tf-api-sg" {
  name        = "tf-api-sg"
  description = "Movie Analyst API SG - TF"
  vpc_id      = data.aws_vpc.ramp-up-vpc.id

  ingress {
    from_port   = var.be_port
    to_port     = var.be_port
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
    responsible = var.responsible_tag
    project = var.project_tag
  }
}

resource "aws_lb_target_group" "tf-api-tg" {
  name     = "tf-api-tg"
  port     = var.be_port
  protocol = "TCP"
  vpc_id   = data.aws_vpc.ramp-up-vpc.id
}

resource "aws_lb" "tf-api-lb" {
  name               = "tf-api-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = [var.subnet_private0, var.subnet_private1]
  tags = {
    responsible = var.responsible_tag
    project = var.project_tag
  }
}

resource "aws_lb_listener" "tf-api-l" {
  load_balancer_arn = aws_lb.tf-api-lb.arn
  port              = var.be_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf-api-tg.arn
  }
}

resource "aws_launch_template" "tf-api-t" {
  name          = "tf-api-t"
  image_id      = var.ami_id
  instance_type = "t2.micro"
  key_name = var.key_pair
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.tf-api-sg.id]
  }

  user_data = filebase64("${path.module}/scripts/be-bootstrap.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      responsible = var.responsible_tag
      project = var.project_tag
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      responsible = var.responsible_tag
      project = var.project_tag
    }
  }
}

resource "aws_autoscaling_group" "tf-api-asg" {
  vpc_zone_identifier = [var.subnet_private0, var.subnet_private1]
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
    value = var.responsible_tag
    propagate_at_launch = true
  }

  tag {
    key = "project"
    value = var.project_tag
    propagate_at_launch = true
  }
}
