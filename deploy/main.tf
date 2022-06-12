provider "aws" {
    region = "us-east-1"
}

resource "aws_ecs_task_definition" "test-task-definition" {
  container_definitions = jsonencode(
    [
      {
        cpu               = 128
        essential         = true
        image             = "553652254709.dkr.ecr.us-east-1.amazonaws.com/test:latest"
        memory            = 2048
        memoryReservation = 256
        name              = var.project-name

        portMappings = [
          {
            containerPort = 3000
          },
        ]
        logConfiguration = {}
      }
    ]
  )
  family        = "${var.project-name}-task"
  task_role_arn = ""
}