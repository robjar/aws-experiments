provider "aws" {
    region = "us-east-1"
}

variable "project-name" {
  type = string
  default = "project-name-default-name"
}

variable "vpc-id" {
  type = string
}

resource "aws_lb" "test-load-balancer" {
  name               = "test-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-0916376864a44675e"]
  subnets            = ["subnet-fc1b06b1", "subnet-c93c7296", "subnet-24ab3a15"]

  enable_deletion_protection = false
}

resource "aws_lb_listener" "test-lb-listener" {
  load_balancer_arn = aws_lb.test-load-balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test-service-target-group.arn
  }
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
      }
    ]
  )
  family        = "${var.project-name}-task"
  task_role_arn = ""
}

resource "aws_ecs_service" "test-service" {
  cluster                            = "arn:aws:ecs:us-east-1:553652254709:cluster/default"
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 75
  desired_count                      = 2
  name                               = "${var.project-name}-srv"
  task_definition                    = "${aws_ecs_task_definition.test-task-definition.id}:${aws_ecs_task_definition.test-task-definition.revision}"

  load_balancer {
    container_name   = var.project-name
    container_port   = 3000
    target_group_arn = aws_lb_target_group.test-service-target-group.arn
  }
}

resource "aws_lb_target_group" "test-service-target-group" {
  name     = var.project-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc-id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}