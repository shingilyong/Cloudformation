resource "aws_security_group" "terraform-bastion-sg" {
    vpc_id              = "${aws_vpc.terraform_test.id}"
    name                = "terraform-bastion-sg"
    tags = {
        Name            = "terraform-bastion-sg"
    }
}


resource "aws_security_group" "terraform-External-ELB-sg" {
    vpc_id              = "${aws_vpc.terraform_test.id}"
    name                = "terraform-External-ELB-sg"
    tags = {
        Name            = "terraform-External-ELB-sg"
    }
}


resource "aws_security_group" "terraform-web-sg" {
    vpc_id              = "${aws_vpc.terraform_test.id}"
    name                = "terraform-web-sg"
    tags = {
        Name            = "terraform-web-sg"
    }
}

    resource "aws_security_group" "terraform-Internal-ELB-sg" {
    vpc_id              = "${aws_vpc.terraform_test.id}"
    name                = "terraform-Internal-ELB-sg"
    tags = {
        Name            = "terraform-Internal-ELB-sg"
    }
}

    resource "aws_security_group" "terraform-was-sg" {
    vpc_id              = "${aws_vpc.terraform_test.id}"
    name                = "terraform-was.sg"
    tags = {
        Name            = "terraform-was.sg"
    }
}

    resource "aws_security_group" "terraform-db-sg" {
    vpc_id              = "${aws_vpc.terraform_test.id}"
    name                = "terraform-db.sg"
    tags = {
        Name            = "terraform-db.sg"
    }
}