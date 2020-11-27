resource "aws_security_group" "tf-api-sg" {
  name        = "tf-api-sg"
  description = "Movie Analyst API SG - TF"
  vpc_id      = var.vpc_id

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

  tags = merge(
    var.tags,
    {
      Name = "tf-api-sg"
    }
  )
}

resource "aws_lb_target_group" "tf-api-tg" {
  name     = "tf-api-tg"
  port     = var.be_port
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

resource "aws_lb" "tf-api-lb" {
  name               = "tf-api-lb"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnets
  tags = var.tags
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
  instance_type = var.instance_type
  key_name = var.key_pair
  
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.tf-api-sg.id]
  }

  user_data = filebase64("${path.module}/../../scripts/be-bootstrap.sh")

  tag_specifications {
    resource_type = "instance"
    tags = var.tags
  }

  tag_specifications {
    resource_type = "volume"
    tags = var.tags
  }
}

resource "aws_autoscaling_group" "tf-api-asg" {
  name                = "tf-api-asg"
  vpc_zone_identifier = var.subnets
  desired_capacity    = 2
  max_size            = 3
  min_size            = 2
  target_group_arns   = [aws_lb_target_group.tf-api-tg.arn]

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
