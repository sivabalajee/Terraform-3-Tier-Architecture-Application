module "ecs_cluster_fargate" {
  source = "terraform-aws-modules/ecs/aws"

  version = "3.4.0"

  name = var.cluster_name

  capacity_providers = var.capacity_provider

  default_capacity_provider_strategy = [
    {
      capacity_provider = var.default_capacity_provider
    }
  ]

  container_insights = var.container_insights_enabled

}

resource "aws_ecs_service" "service" {
  name    = "${local.service_name}-test"
  cluster = module.ecs_cluster_fargate.ecs_cluster_arn

  launch_type     = "FARGATE"
  desired_count   = var.wordpress["desired_count"]
  task_definition = aws_ecs_task_definition.main.arn

  enable_execute_command = true

  health_check_grace_period_seconds = 10


  network_configuration {
    subnets         = data.aws_subnet.private.*.id
    security_groups = [aws_security_group.wordpress.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name   = "wordpress"
    container_port   = 80
  }
}

resource "aws_ecs_task_definition" "main" {
  family = "wordpress"

  execution_role_arn = aws_iam_role.exec.arn
  task_role_arn      = aws_iam_role.task.arn

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.wordpress["cpu"]
  memory                   = var.wordpress["memory"]

  container_definitions = jsonencode([
    {
      name        = "wordpress"
      image       = "wordpress:php8.2-apache"
      environment = local.environment
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
          hostPort      = 80
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.cloudwatch_log_group
          awslogs-region        = var.region
          awslogs-stream-prefix = "${local.name}-wordpress"
        }
      }
    }
  ])

}
