resource "aws_ecs_service" "main" {
  name=var.ServiceName
  cluster         = var.ClusterId
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = var.TaskCount
  launch_type = "FARGATE"

  load_balancer {
    target_group_arn = var.TargetGroupArn
    container_name   = var.ServiceName
    container_port   = 8080
  }
  network_configuration{
    subnets=var.ServiceSubnets
    security_groups = var.ServiceSecurityGroups
    assign_public_ip=true
  }



}
