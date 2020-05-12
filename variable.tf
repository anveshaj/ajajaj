variable "hbiregion" {
  default = "us-east-1"
}
variable "vpccidr" {
  default = "10.200.0.0/16"
}

variable "myamis" {
  type = "map"
  default = {

      us-east-1 = "ami-0323c3dd2da7fb37d"
      us-east-2 = "ami-0f7919c33c90f5b58"
      us-west-1 = "ami-06fcc1f0bc2c8943f"
      us-west-2 = "ami-0d6621c01e8c2de2c"

      }
}

variable "ec2-type" {
  default = "t2.micro"
}
