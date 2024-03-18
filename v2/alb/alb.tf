resource "aws_lambda_function_url" "hex7" {
  function_name      = aws_lambda_function.hex7.function_name
  authorization_type = "NONE"
}

resource "aws_vpc" "hex7" {
  cidr_block = "192.168.220.0/23"
  tags       = var.tags
}


resource "aws_subnet" "hex7_1" {
  cidr_block        = "192.168.220.0/24"
  vpc_id            = aws_vpc.hex7.id
  tags              = var.tags
}


resource "aws_subnet" "hex7_2" {
  cidr_block        = "192.168.221.0/24"
  vpc_id            = aws_vpc.hex7.id
  tags              = var.tags
}


resource "aws_internet_gateway" "hex7" {
  vpc_id = aws_vpc.hex7.id
  tags   = var.tags
}


resource "aws_route_table" "hex7" {
  vpc_id = aws_vpc.hex7.id
  tags   = var.tags

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.hex7.id
  }
}


resource "aws_route_table_association" "hex7_1" {
  subnet_id      = aws_subnet.hex7_1.id
  route_table_id = aws_route_table.hex7.id
}


resource "aws_route_table_association" "hex7_2" {
  subnet_id      = aws_subnet.hex7_2.id
  route_table_id = aws_route_table.hex7.id
}


resource "aws_security_group" "hex7" {
  name              = "allow_alb"
  vpc_id            = aws_vpc.hex7.id
  tags              = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.hex7.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https" {
  security_group_id = aws_security_group.hex7.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}


resource "aws_lb" "hex7" {
  depends_on         = [ aws_lambda_function.hex7 ]
  name               = "hex7"
  internal           = false
  security_groups    = [ aws_security_group.hex7.id ]
  load_balancer_type = "application"
  subnets            = [ aws_subnet.hex7_1.id,
                         aws_subnet.hex7_2.id ]

  access_logs {
    bucket  = aws_s3_bucket.hex7.id
    enabled = false
  }

  tags = var.tags
}


resource "aws_lb_listener" "hex7" {
  load_balancer_arn = aws_lb.hex7.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hex7.arn
  }
}


#resource "aws_lb_listener" "hex7" {
  #load_balancer_arn = aws_lb.hex7.arn
  #port              = "443"
  #protocol          = "HTTPS"
  #ssl_policy        = "ELBSecurityPolicy-2016-08"
  #certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

  #default_action {
  #  type             = "forward"
  #  target_group_arn = aws_lb_target_group.hex7.arn
  #}
#}


resource "aws_lb_target_group" "hex7" {
  name        = aws_lambda_function.hex7.function_name
  target_type = "lambda"
}


resource "aws_lambda_permission" "hex7" {
  statement_id = "AllowExecutionFromALB"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.hex7.function_name
  principal = "elasticloadbalancing.amazonaws.com"
  source_arn = aws_lb_target_group.hex7.arn
}


resource "aws_lb_target_group_attachment" "hex7" {
  target_group_arn = aws_lb_target_group.hex7.arn
  target_id        = aws_lambda_function.hex7.arn
  depends_on       = [ aws_lambda_permission.hex7 ]
}
