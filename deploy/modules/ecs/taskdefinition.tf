
resource "aws_ecs_task_definition" "main"{
  container_definitions    = jsonencode(var.ContainerDefinitios)
  cpu                      = "512"
  execution_role_arn       = ""
  family                   = var.ServiceName
  memory                   = "1024"
  network_mode             = "awsvpc"
  requires_compatibilities = [
    "FARGATE",
  ]
  tags                     = {
    name="${var.EnvironmentName}-${var.TaskName}"
  }
  task_role_arn            = ""

}
