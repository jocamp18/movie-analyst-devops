resource "aws_security_group" "tf-b-sg" {
  name        = "tf-b-sg"
  description = "Movie Analyst Bastion - TF"
  vpc_id      = var.vpc_id

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
      Name = "tf-b-sg"
    }
  )
}


resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags          = var.tags
  volume_tags   = var.tags
  key_name      = var.key_pair
  subnet_id     = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.tf-b-sg.id]
  associate_public_ip_address = true
}
