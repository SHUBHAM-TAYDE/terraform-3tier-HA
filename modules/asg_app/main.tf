
resource "aws_iam_role" "ec2_role" {
name = "${var.name}-ec2-role"
assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}


data "aws_iam_policy_document" "ec2_assume_role" {
statement {
actions = ["sts:AssumeRole"]
principals {
type = "Service"
identifiers = ["ec2.amazonaws.com"]
}
}
}


resource "aws_iam_role_policy_attachment" "ssm_core" {
role = aws_iam_role.ec2_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "profile" {
name = "${var.name}-instance-profile"
role = aws_iam_role.ec2_role.name
}


resource "aws_launch_template" "lt" {
name_prefix = "${var.name}-lt-"
image_id = var.ami_id
instance_type = var.instance_type
iam_instance_profile {
name = aws_iam_instance_profile.profile.name
}
user_data = base64encode(templatefile("${path.module}/user_data.sh.tpl", { name = var.name }))
}


resource "aws_autoscaling_group" "asg" {
name = "${var.name}-asg"
max_size = var.max
min_size = var.min
desired_capacity = var.desired
vpc_zone_identifier = var.private_subnet_ids


launch_template {
id = aws_launch_template.lt.id
version = "$Latest"
}


target_group_arns = [var.target_group_arn]
health_check_type = "ELB"
health_check_grace_period = 120
tag {
key = "Name"
value = "${var.name}-instance"
propagate_at_launch = true
}
}
