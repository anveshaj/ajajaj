
resource "aws_subnet" "public-subnet" {
  count = "${length(local.tzones)}"
  vpc_id     = "${aws_vpc.hbi_vpc.id}"
  cidr_block = "${cidrsubnet(var.vpccidr, 8, (count.index +1) * 10 )}"
  availability_zone = "${local.tzones[count.index]}"
  map_public_ip_on_launch = true
  tags = {
    Name = "hbi_public-subnet- ${terraform.workspace}"
    environment = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "hbi_igw" {
  vpc_id = "${aws_vpc.hbi_vpc.id}"

  tags = {
    Name = "hbi_igw"
  }
}

resource "aws_route_table" "hbi_public_route" {
  vpc_id = "${aws_vpc.hbi_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.hbi_igw.id}"
  }

  tags = {
    Name = "hbi_public_route"
  }
}

resource "aws_route_table_association" "pubassociation" {
  count = "${length(local.tzones)}"
  subnet_id      = "${local.pubsub[count.index]}"
  route_table_id = "${aws_route_table.hbi_public_route.id}"
}
