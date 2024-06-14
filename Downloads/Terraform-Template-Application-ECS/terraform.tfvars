prefix = "test-interview"


cluster_name               = "test-cluster"
capacity_provider          = ["FARGATE", "FARGATE_SPOT"]
default_capacity_provider  = "FARGATE"
container_insights_enabled = true

rds = {
  identifier                 = "test-db"
  instance_class             = "db.t3.micro"
  major_engine_version       = 5.7
  auto_minor_version_upgrade = true
  allocated_storage          = 10
  engine                     = "mysql"
  db_name                    = "wordpress"
}

wordpress = {
  cpu           = 256
  memory        = 512
  desired_count = 1
}

cloudwatch_log_group = "/ECS/interview/wordpress"

rds_username = "testuser"
rds_password = "testpassword"
