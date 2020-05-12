locals {


    tzones = "${data.aws_availability_zones.available-zones.names}"
    pubsub = "${aws_subnet.public-subnet.*.id}"
    pvtsub = "${aws_subnet.private-subnet.*.id}"

}
