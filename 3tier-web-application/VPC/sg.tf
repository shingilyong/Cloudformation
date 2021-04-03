# bastion-sg 생성
resource "aws_security_group" "terraform-bastion-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-bastion-sg"
    tags = {
        Name            = "terraform-bastion-sg"
    }
}

# External-ELB-sg 생성
resource "aws_security_group" "terraform-External-ELB-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-External-ELB-sg"
    tags = {
        Name            = "terraform-External-ELB-sg"
            }
}

# web-sg 생성
resource "aws_security_group" "terraform-web-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-web-sg"
    tags = {
        Name            = "terraform-web-sg"
    }
}

# internal-ELB-sg 생성
    resource "aws_security_group" "terraform-Internal-ELB-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-Internal-ELB-sg"
    tags = {
        Name            = "terraform-Internal-ELB-sg"
    }
}

# was-sg 생성
    resource "aws_security_group" "terraform-was-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-was.sg"
    tags = {
        Name            = "terraform-was.sg"
    }
}

# db-sg 생성
    resource "aws_security_group" "terraform-db-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
        name                = "terraform-db.sg"
    tags = {
        Name            = "terraform-db.sg"
    }
}


# terraform-bastion-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-bastion-sg-role" {
    type                = "ingress"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-bastion-sg.id}"
    
}

# terraform-bastion-sg 아웃바운드 규칙 추가
resource "aws_security_group_rule" "terraform-bastion-sg-role1" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-bastion-sg.id}"
    
}

# terraform-External-ELB-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-External-ELB-sg-role" {
    type                = "ingress"
    from_port           = 80
    to_port             = 80
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-External-ELB-sg.id}"
}

# terraform-External-ELB-sg 아웃바운드 규칙 추가
resource "aws_security_group_rule" "terraform-External-ELB-sg-role1" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-External-ELB-sg.id}"
    
}


# terraform-web-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-web-role" {
    type                         = "ingress"
    from_port                    = 80
    to_port                      = 80
    protocol                     = "tcp"

    security_group_id            = "${aws_security_group.terraform-web-sg.id}"
    source_security_group_id     = "${aws_security_group.terraform-External-ELB-sg.id}"
}

# terraform-web-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-web-role1" {
    type                         = "ingress"
    from_port                    = 22
    to_port                      = 22
    protocol                     = "tcp"
    cidr_blocks                  = ["0.0.0.0/0"]

    security_group_id            = "${aws_security_group.terraform-web-sg.id}"
}

# terraform-web-sg 아웃바운드 규칙 추가
resource "aws_security_group_rule" "terraform-web-sg-role2" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-web-sg.id}"
    
}

# terraform-Internal-ELB-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-Internal-ELB-sg-role" {
    type                = "ingress"
    from_port           = 8080
    to_port             = 8080
    protocol            = "tcp"

        security_group_id   = "${aws_security_group.terraform-Internal-ELB-sg.id}"
    source_security_group_id     = "${aws_security_group.terraform-web-sg.id}"

}

# terraform-Internal-ELB-sg 아웃바운드 규칙 추가
resource "aws_security_group_rule" "terraform-Internal-ELB-sg-role1" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-Internal-ELB-sg.id}"
    
}


# terraform-was-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-was-sg-role" {
    type                = "ingress"
    from_port           = 8080
    to_port             = 8080
    protocol            = "tcp"


    security_group_id   = "${aws_security_group.terraform-was-sg.id}"
    source_security_group_id     = "${aws_security_group.terraform-Internal-ELB-sg.id}"

}

# terraform-was-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-was-sg-role1" {
    type                = "ingress"

        from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks                  = ["0.0.0.0/0"]



    security_group_id   = "${aws_security_group.terraform-was-sg.id}"

}

# terraform-was-sg 아웃바운드 규칙 추가
resource "aws_security_group_rule" "terraform-was-sg-role2" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-was-sg.id}"
}

# terraform-db-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-db-sg-role" {
    type                = "ingress"
    from_port           = 3306
    to_port             = 3306
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]

        security_group_id   = "${aws_security_group.terraform-db-sg.id}"
}


# terraform-was-sg 아웃바운드 규칙 추가
resource "aws_security_group_rule" "terraform-db-sg-role1" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-db-sg.id}"
}
