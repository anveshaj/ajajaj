resource "aws_launch_configuration" "web_launch_config" {
  name            = "web_launch_config"
  image_id        = "${var.myamis[var.hbiregion]}"
  instance_type   = "${var.ec2-type}"
  key_name        = "${aws_key_pair.ajkey.key_name}"
  security_groups = ["${aws_security_group.webserverSG.id}"]
  user_data       = "${file("myscripts/httpinstall.sh")}"

}

resource "aws_autoscaling_group" "hbi-asg" {
  name                      = "hbi-asg"
  max_size                  = 5
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 60
  health_check_type         = "ELB"
  load_balancers            = ["${aws_elb.hbi-elb.name}"]
  launch_configuration      = "${aws_launch_configuration.web_launch_config.name}"
  vpc_zone_identifier       = "${local.pubsub}"

  tag {
    key                 = "Name"
    value               = "webserver"
    propagate_at_launch = true
  }
  tag {
    key                 = "environment"
    value               = "${terraform.workspace}"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "increasing-asg-policy" {
  name                   = "increasing-asg-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.hbi-asg.name}"
}

resource "aws_autoscaling_policy" "decreasing-asg-policy" {
  name                   = "decreasing-asg-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = "${aws_autoscaling_group.hbi-asg.name}"
}

resource "aws_cloudwatch_metric_alarm" "critical-metric" {
  alarm_name          = "critical-metric"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "85"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.hbi-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.increasing-asg-policy.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "ok-metric" {
  alarm_name          = "ok-metric"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "40"

  dimensions = {
    AutoScalingGroupName = "${aws_autoscaling_group.hbi-asg.name}"
  }

  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions     = ["${aws_autoscaling_policy.decreasing-asg-policy.arn}"]
}
