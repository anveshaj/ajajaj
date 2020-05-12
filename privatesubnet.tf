
resource "aws_subnet" "private-subnet" {
  count = "${length(slice(local.tzones, 0, 3))}"
  vpc_id     = "${aws_vpc.hbi_vpc.id}"
  cidr_block = "${cidrsubnet(var.vpccidr, 8, (length(local.tzones) + count.index +1) *10) }"
  availability_zone = "${local.tzones[count.index]}"
  tags = {
    Name = "private-subnet-${terraform.workspace}"
    environment = "${terraform.workspace}"
  }
}

resource "aws_eip" "eipa" {
}

resource "aws_nat_gateway" "hbinatgw" {
  allocation_id = "${aws_eip.eipa.id}"
  subnet_id     = "${local.pubsub[0]}"

  tags = {
    Name = "HBI_NAT-gw"
  }
}

resource "aws_route_table" "hbi_private_route" {
  vpc_id = "${aws_vpc.hbi_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_nat_gateway.hbinatgw.id}"
  }

  tags = {
    Name = "hbi_private_route"
  }
}

resource "aws_route_table_association" "pvtassociation" {
  count = "${length(slice(local.tzones, 0, 3))}"
  subnet_id      = "${local.pvtsub[count.index]}"
  route_table_id = "${aws_route_table.hbi_private_route.id}"
}
