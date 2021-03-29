# vpc 생성
resource "aws_vpc" "terraform_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
    Name = "terraform_vpc"
    }
}

# public subnet1 생성
resource "aws_subnet" "terraform-public-1" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.0.0/24"
    availability_zone   = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-public-1"
    }
}

# public subnet2 생성
resource "aws_subnet" "terraform-public-2" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.10.0/24"
    availability_zone   = "ap-northeast-2c"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-public-2"
    }
}

# private web subnet1 생성
resource "aws_subnet" "terraform-web-1" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.1.0/24"
    availability_zone   = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-web-1"
    }
}

# private web subnet2 생성
resource "aws_subnet" "terraform-web-2" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.11.0/24"
    availability_zone   = "ap-northeast-2c"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-web-2"
    }
}

# private was subnet1 생성
resource "aws_subnet" "terraform-was-1" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.2.0/24"
    availability_zone   = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-was-1"
    }
}

# private was subnet2 생성
resource "aws_subnet" "terraform-was-2" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.12.0/24"
    availability_zone   = "ap-northeast-2c"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-was-2"
    }
}
# private db subnet1 생성
resource "aws_subnet" "terraform-db-1" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.3.0/24"
    availability_zone   = "ap-northeast-2a"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-db-1"
    }
}

# private db subnet2 생성
resource "aws_subnet" "terraform-db-2" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    cidr_block          = "10.0.13.0/24"
    availability_zone   = "ap-northeast-2c"
    map_public_ip_on_launch = false
    tags = {
        Name = "terraform-db-2"
    }
}

# Internet gateway 생성
resource "aws_internet_gateway" "terraform_IGW" {
  vpc_id = aws_vpc.terraform_vpc.id

  tags = {
    Name = "terraform_IGW"
  }
}

# Elastic IP 생성
resource "aws_eip" "terraform-NAT-eip" {   
    vpc      = true
    tags = {
        Name = "terraform-NAT-eip"
  }
}

# NAT 게이트웨이 생성
resource "aws_nat_gateway" "terraform-NAT" {
  allocation_id = aws_eip.terraform-NAT-eip.id
  subnet_id     = aws_subnet.terraform-public-1.id

  tags = {
    Name = "terraform-NAT"
  }
}



# public 라우팅 테이블 생성 및 IGW 연결
resource "aws_route_table" "terraform-public-route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraform_IGW.id
  }


  tags = {
    Name = "terraform-public-route"
  }
}

# private 라우팅 테이블 생성 및 NAT 연결
resource "aws_route_table" "terraform-private-route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.terraform-NAT.id
  }

  tags = {
    Name = "terraform-private-route"
  }
}



# 라우팅 테이블에 public subnet 추가
resource "aws_route_table_association" "public-route" {
  subnet_id      = aws_subnet.terraform-public-1.id
  route_table_id = aws_route_table.terraform-public-route.id
}
resource "aws_route_table_association" "public-route1" {
  subnet_id      = aws_subnet.terraform-public-2.id
  route_table_id = aws_route_table.terraform-public-route.id
}

# 라우팅 테이블에 private subnet 추가
resource "aws_route_table_association" "private-route" {
  subnet_id      = aws_subnet.terraform-web-1.id
  route_table_id = aws_route_table.terraform-private-route.id
}
resource "aws_route_table_association" "private-route1" {
  subnet_id      = aws_subnet.terraform-web-2.id
  route_table_id = aws_route_table.terraform-private-route.id
}
resource "aws_route_table_association" "private-route2" {
  subnet_id      = aws_subnet.terraform-was-1.id
  route_table_id = aws_route_table.terraform-private-route.id
}
resource "aws_route_table_association" "private-route3" {
  subnet_id      = aws_subnet.terraform-was-2.id
  route_table_id = aws_route_table.terraform-private-route.id
}
resource "aws_route_table_association" "private-route4" {
  subnet_id      = aws_subnet.terraform-db-1.id
  route_table_id = aws_route_table.terraform-private-route.id
}
resource "aws_route_table_association" "private-route5" {
  subnet_id      = aws_subnet.terraform-db-2.id
  route_table_id = aws_route_table.terraform-private-route.id
}

# bastion Security group 생성
resource "aws_security_group" "terraform-bastion-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-bastion-sg"
    tags = {
        Name            = "terraform-bastion-sg"
    }
}

# External-ELB Security group 생성
resource "aws_security_group" "terraform-External-ELB-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-External-ELB-sg"
    tags = {
        Name            = "terraform-External-ELB-sg"
    }
}

# web Security group 생성
resource "aws_security_group" "terraform-web-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-web-sg"
    tags = {
        Name            = "terraform-web-sg"
    }
}

# Internal-ELB Security group 생성
    resource "aws_security_group" "terraform-Internal-ELB-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-Internal-ELB-sg"
    tags = {
        Name            = "terraform-Internal-ELB-sg"
    }
}

# was Security group 생성
    resource "aws_security_group" "terraform-was-sg" {
    vpc_id              = "${aws_vpc.terraform_vpc.id}"
    name                = "terraform-was.sg"
    tags = {
        Name            = "terraform-was.sg"
    }
}

# db Security group 생성
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


    security_group_id   = "${aws_security_group.terraform-was-sg.id}"
    source_security_group_id     = "${aws_security_group.terraform-Internal-ELB-sg.id}"

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