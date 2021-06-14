resource "aws_rds_cluster" "main" {
  availability_zones = [
    "ap-northeast-1a",
    "ap-northeast-1c",
    "ap-northeast-1d",
  ]
  final_snapshot_identifier           = "portforio"
  snapshot_identifier                 = "portforio"
  backtrack_window                    = 0
  backup_retention_period             = 1
  cluster_identifier                  = "database-2"
  cluster_members                     = []
  copy_tags_to_snapshot               = true
  db_cluster_parameter_group_name     = "default.aurora-mysql5.7"
  db_subnet_group_name                = "aurora-private"
  deletion_protection                 = false
  enable_http_endpoint                = false
  enabled_cloudwatch_logs_exports     = []
  engine                              = "aurora-mysql"
  engine_mode                         = "serverless"
  engine_version                      = "5.7.mysql_aurora.2.07.1"
  iam_database_authentication_enabled = false
  iam_roles                           = []
  kms_key_id                          = ""
  master_username                     = "admin"
  port                                = 3306
  preferred_backup_window             = "19:58-20:28"
  preferred_maintenance_window        = "wed:17:58-wed:18:28"
  skip_final_snapshot                 = true
  storage_encrypted                   = true
  tags                                = {}
  tags_all                            = {}
  vpc_security_group_ids = [
    "sg-78473b34",
  ]

  scaling_configuration {
    auto_pause               = false
    max_capacity             = 64
    min_capacity             = 1
    seconds_until_auto_pause = 300
    timeout_action           = "RollbackCapacityChange"
  }

  timeouts {}

}

output "db_endpoint"{
  value=aws_rds_cluster.main.endpoint
}

data "aws_db_cluster_snapshot" "latest_prod_snapshot" {
  db_cluster_identifier = aws_rds_cluster.main.id
  most_recent            = true
}
