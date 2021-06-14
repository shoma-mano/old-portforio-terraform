variable "EnvironmentName" {
  default = ""
}
resource "aws_ecs_cluster" "main" {
  capacity_providers = [
    "FARGATE",
    "FARGATE_SPOT",
  ]
  name               = "DEVELOP"
  tags               = {
    name="${var.EnvironmentName}-Cluster"
  }
  tags_all           = {}

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

}

output "ClusterId"{
  value=aws_ecs_cluster.main.id
}