resource "aws_lb" "lb" {
  name               = "lb"
  subnets = ["${aws_subnet.web_subnet.id}", "${aws_subnet.web_subnet2.id}"]
  security_groups    = ["${aws_security_group.terraform-External-ELB-sg.id}"]
  load_balancer_type = "application"

  tags = {
    Name = "lb"
      }
}

# target group 생성
resource "aws_alb_target_group" "tg" {
  name     = "tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.web_vpc.id

  health_check {
  interval            = 30
  path                = "/"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  }
}

# alb 리스너 설정
resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_lb.lb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.tg.arn}"
    type             = "forward"
  }
}
