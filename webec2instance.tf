/*
resource "aws_instance" "web" {
  count = 3
  ami = "${var.myamis[var.hbiregion]}"
  instance_type = "${var.ec2-type}"
  subnet_id = "${local.pubsub[count.index]}"
  user_data = "${file("myscripts/httpinstall.sh")}"
  vpc_security_group_ids = ["${aws_security_group.webserverSG.id}"]
  key_name = "${aws_key_pair.ajkey.key_name}"
  tags = {
    Name = "WEB-SERVER-${count.index + 1}"
    environment = "${terraform.workspace}"
  }
}
*/
