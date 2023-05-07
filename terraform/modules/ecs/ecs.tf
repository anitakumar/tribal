# cluster
resource "aws_ecs_cluster" "this-cluster" {
  name = var.name
}

resource "aws_launch_configuration" "ecs-this-launchconfig" {
  name_prefix          = var.name
  image_id             = var.ami
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs-ec2-role.id
  security_groups      = [aws_security_group.this-ecs-securitygroup.id]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=this-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs-this-autoscaling" {
  name                 = var.name
  vpc_zone_identifier  = [aws_subnet.this-public-1.id, aws_subnet.this-public-2.id]
  launch_configuration = aws_launch_configuration.ecs-this-launchconfig.name
  min_size             = 1
  max_size             = 1
  tag {
    key                 = var.name
    value               = "ecs-ec2-container"
    propagate_at_launch = true
  }
}

