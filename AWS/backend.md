main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}



provider "aws" {
  region = var.region
}

######################
# DATA: Latest AMI
######################
data "aws_ami" "latest_docker_ami" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["docker-engine-ubuntu-ami-*"]
  }
}

######################
# FRONTEND Launch Template + ASG
######################
resource "aws_launch_template" "frontend" {
  name_prefix   = "frontend-lt"
  image_id      = data.aws_ami.latest_docker_ami.id
  instance_type = "t2.micro"
  key_name      = "ranjitha"
  user_data = base64encode(file("${path.module}/frontend_user_data.sh"))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.security_group_id]
  }
}

resource "aws_autoscaling_group" "frontend" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.frontend.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.frontend.arn]
  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "frontend-instance"
    propagate_at_launch = true
  }
}

######################
# FRONTEND ALB
######################
resource "aws_lb" "frontend" {
  name               = "frontend-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.security_group_id]
}

resource "aws_lb_target_group" "frontend" {
  name     = "frontend-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id


}

resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend.arn
  }
}




######################
# BACKEND Launch Template + ASG
######################
resource "aws_launch_template" "backend" {
  name_prefix   = "backend-lt"
  image_id      = data.aws_ami.latest_docker_ami.id
  instance_type = "t2.micro"
  key_name      = "ranjitha"
  user_data = base64encode(templatefile("${path.module}/frontend_user_data.sh", {
    rds_endpoint = var.rds_endpoint
  }))

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [var.security_group_id]
  }
}

resource "aws_autoscaling_group" "backend" {
  desired_capacity    = 2
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = var.public_subnets

  launch_template {
    id      = aws_launch_template.backend.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.backend.arn]
  health_check_type = "EC2"

  tag {
    key                 = "Name"
    value               = "backend-instance"
    propagate_at_launch = true
  }
}

######################
# BACKEND ALB
######################

resource "aws_lb_target_group" "backend" {
  name     = "backend-tg"
  port     = 8081
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"  # or "/health" if your backend exposes that
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_listener" "backend_http" {
  load_balancer_arn = aws_lb.frontend.arn  # reusing same ALB
  port              = 8081
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.backend.arn
  }
}
######################
# RDS: MySQL
######################
#resource "aws_db_subnet_group" "public_subnet_group" {
#  name       = "public-subnet-group"
#  subnet_ids = var.public_subnets

#  tags = {
#    Name = "public-rds-subnet-group"
#  }
#}

#resource "aws_db_instance" "mydb" {
#  identifier              = "springboot-mysql"
#  engine                  = "mysql"
#  instance_class          = "db.t3.micro"
#  allocated_storage       = 20
#  db_name                 = "employees"
#  username                = "admin"
#  password                = "admin1234"

#  parameter_group_name    = "default.mysql8.0"
#  db_subnet_group_name    = aws_db_subnet_group.public_subnet_group.name

#  vpc_security_group_ids  = [var.security_group_id]

#  skip_final_snapshot     = true
#  publicly_accessible     = true
#  deletion_protection     = false

#  tags = {
#    Name = "springboot-mysql"
#  }
#}

