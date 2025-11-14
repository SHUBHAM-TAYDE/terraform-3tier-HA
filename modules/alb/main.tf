variable "name" {}
variable "public_subnet_ids" { type = list(string) }
variable "vpc_id" {}


resource "aws_security_group" "alb_sg" {
name = "${var.name}-alb-sg"
vpc_id = var.vpc_id


ingress {
from_port = 80
to_port = 80
protocol = "tcp"
cidr_blocks = ["0.0.0.0/0"]
}


egress {
from_port = 0
to_port = 0
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}


resource "aws_lb" "alb" {
name = "${var.name}-alb"
internal = false
load_balancer_type = "application"
subnets = var.public_subnet_ids
security_groups = [aws_security_group.alb_sg.id]
}


resource "aws_lb_target_group" "tg" {
name = "${var.name}-tg"
port = 80
protocol = "HTTP"
vpc_id = var.vpc_id
health_check {
path = "/"
interval = 30
healthy_threshold = 2
unhealthy_threshold = 2
timeout = 5
}
}


resource "aws_lb_listener" "http" {
load_balancer_arn = aws_lb.alb.arn
port = "80"
protocol = "HTTP"
default_action {
type = "forward"
target_group_arn = aws_lb_target_group.tg.arn
}
}


output "alb_dns" { value = aws_lb.alb.dns_name }
output "target_group_arn" { value = aws_lb_target_group.tg.arn }