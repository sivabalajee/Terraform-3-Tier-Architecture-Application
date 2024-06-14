resource "aws_security_group" "alb" {
  name        = "${local.name}-sg-alb"
  vpc_id      = data.aws_vpc.main.id
  description = "ALB security group for ${local.name}"
}

resource "aws_security_group_rule" "alb_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  description       = "Allow all egress traffic"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sg
  security_group_id = aws_security_group.alb.id

}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  to_port           = 80
  protocol          = "tcp"
  from_port         = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "ALB HTTP access"
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "wordpress" {
  name        = "${local.name}-wordpress"
  vpc_id      = data.aws_vpc.main.id
  description = "ECS security group for ${local.name}-wordpress"

  egress {
    to_port     = 0
    protocol    = -1
    from_port   = 0
    cidr_blocks = ["0.0.0.0/0"] #tfsec:ignore:aws-vpc-no-public-egress-sg
    description = "ECS Allow All Egress Traffic"
  }
}

resource "aws_security_group_rule" "alb_wordpress" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  description              = "HTTP Traffic from ALB"
  security_group_id        = aws_security_group.wordpress.id
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "rds" {
  name        = "${local.name}-sg-rds"
  vpc_id      = data.aws_vpc.main.id
  description = "rds security group for ${local.name}"
}

resource "aws_security_group_rule" "ingress_ecs" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.wordpress.id
  security_group_id        = aws_security_group.rds.id
  description              = "Access from ECS Wordpress"
}
