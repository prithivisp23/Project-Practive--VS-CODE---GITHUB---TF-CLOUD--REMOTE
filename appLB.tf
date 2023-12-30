#Application load balancer
resource "aws_lb" "alb" {
  name               = "my-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.pub-seg.id]
    tags = {
    Name = "ALB"
  }
  #Subnet mapping of VPC public subnet 1 & 2 
  subnet_mapping {
    subnet_id     = aws_subnet.pubsub1.id
  }
    subnet_mapping {
    subnet_id     = aws_subnet.pubsub2.id
  }
}
  # Targert group creation for load balancer
  resource "aws_lb_target_group" "alb-tg" {
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id # associate vpc id - name
}

 # Listener group creation and association with target group , load balancer 
 resource "aws_lb_listener" "alb-listener" {
  load_balancer_arn = aws_lb.alb.arn # associate load balancer name as arn -alb
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb-tg.arn # associate target group name as arn -alb-tg
  }
}

#Target group attachment for instance 1 & 2 and associate with target group
resource "aws_lb_target_group_attachment" "targetinstance1" {
  target_group_arn = aws_lb_target_group.alb-tg.arn # associate with target group using the target group name 
  target_id        = aws_instance.pubweb1.id # provide the name of AWS instance 
}

resource "aws_lb_target_group_attachment" "tginstance2" {
  target_group_arn = aws_lb_target_group.alb-tg.arn # associate with target group using the target group name 
  target_id        = aws_instance.pubweb2.id # provide the name of AWS instance 
}
