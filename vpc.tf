

resource "aws_vpc" "hbi_vpc" {
  cidr_block       = "${var.vpccidr}"
  instance_tenancy = "default"

  tags = {
    Name = "hbi_vpc"
    environment = "${terraform.workspace}"
  }
}
