output "web-NAT" {
    value = "${aws_nat_gateway.web-NAT.id}"
}

output "web-eip" {
    value = "${aws_eip.web-eip.id}"
}

output "web_vpc" {
    value = "${aws_vpc.web_vpc.id}"
}

output "web_IGW" {
    value = "${aws_internet_gateway.web_IGW.id}"
}