resource "aws_lb" "argocd_alb" {
  name               = "argocd-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.argocd_alb_sg.id]
  subnets            = ["subnet-0e4e021e41a410c67", "subnet-0b5289d8f876fb36f"] #todo move to vars

  enable_deletion_protection = false

  tags = {
    devops_task = "true"
  }
}

resource "aws_lb_target_group" "argocd_tg" {
  name     = "argocd-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-017cfae97a6c84f03"  #move to vars

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    devops_task = "true"
  }
}

resource "aws_lb_listener" "argocd_listener" {
  load_balancer_arn = aws_lb.argocd_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.argocd_tg.arn
  }

  tags = {
    devops_task = "true"
  }
}

resource "aws_security_group" "argocd_alb_sg" {
  name   = "argocd-alb-sg"
  vpc_id = "vpc-017cfae97a6c84f03"  #move to vars

  ingress {
    from_port   = 80
    to_port     = 80
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
    devops_task = "true"
  }
}