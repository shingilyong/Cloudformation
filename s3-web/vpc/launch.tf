resource "aws_launch_configuration" "launch" {
    name = "template"
    image_id = "ami-07464b2b9929898f8"
    instance_type = "t2.micro"
    user_data = "${file("web-data.sh")}"
    key_name = "${aws_key_pair.terraform_key.key_name}"
    security_groups = ["${aws_security_group.terraform-web-sg.id}"]
}

resource"aws_autoscaling_group" "ag" {
    name = "ag"
    launch_configuration = aws_launch_configuration.launch.name
    min_size = 1
    max_size = 3
    vpc_zone_identifier       = [aws_subnet.web_subnet.id, aws_subnet.web_subnet2.id]
 

    }

resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = aws_autoscaling_group.ag.id
  alb_target_group_arn   = aws_alb_target_group.tg.arn
}

resource "aws_key_pair" "terraform_key" {
  key_name = "terraform_key"
  public_key = "${file("id_rsa.pub")}"
}