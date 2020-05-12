resource "aws_key_pair" "ajkey" {
  key_name   = "ajkey"
  public_key = "${file("myscripts/webkey.pub")}"
}
