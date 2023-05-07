# app


data "template_file" "this" {
  template = "${file("${path.module}/templates/app.json.tpl")}"
  vars = {
    repo_url = var.repo_url
    app = var.name
  }
}
resource "aws_ecs_task_definition" "this-task-definition" {
  family                = "service"
  container_definitions = data.template_file.this.rendered
}

resource "aws_elb" "this-elb" {
  name = var.name

  listener {
    instance_port     = 5000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 30
    target              = "HTTP:5000/2"
    interval            = 60
  }

  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  subnets         = [aws_subnet.this-public-1.id, aws_subnet.this-public-2.id]
  security_groups = [aws_security_group.this-elb-securitygroup.id]

  tags = {
    Name = var.name
  }
}

resource "aws_ecs_service" "this-service" {
  name            = var.name
  cluster         = aws_ecs_cluster.this-cluster.id
  task_definition = aws_ecs_task_definition.this-task-definition.arn
  desired_count   = 1
  iam_role        = aws_iam_role.ecs-service-role.arn
  depends_on      = [aws_iam_policy_attachment.ecs-service-attach1]

  load_balancer {
    elb_name       = aws_elb.this-elb.name
    container_name = var.name
    container_port = 5000
  }
  lifecycle {
    ignore_changes = [task_definition]
  }
}

