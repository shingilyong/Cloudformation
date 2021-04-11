provider "aws" {

    region     = var.region
}


# vpc 생성
resource "aws_vpc" "web_vpc" {
    cidr_block = "${var.cidr_block["cidr_vpc"]}"
    tags = {
    Name = "web_vpc"
    }
}



# public subnet 생성
resource "aws_subnet" "public_subnet" {
    vpc_id              = aws_vpc.web_vpc.id
    cidr_block          = "${var.cidr_block["cidr_public"]}"
    availability_zone   = var.az["a"]
    map_public_ip_on_launch = false
    tags = {
        Name = "public_subnet"
    }
}

# public subnet 생성
resource "aws_subnet" "public_subnet2" {
    vpc_id              = aws_vpc.web_vpc.id
    cidr_block          = "${var.cidr_block["cidr_public2"]}"
    availability_zone   = var.az["c"]
    map_public_ip_on_launch = false
    tags = {
        Name = "public_subnet2"
    }
}

# web subnet 생성
resource "aws_subnet" "web_subnet" {
    vpc_id              = aws_vpc.web_vpc.id
    cidr_block          = "${var.cidr_block["cidr_web"]}"
    availability_zone   = var.az["a"]
    map_public_ip_on_launch = false
    tags = {
        Name = "web_subnet"
    }
}
# web subnet 생성
resource "aws_subnet" "web_subnet2" {
    vpc_id              = aws_vpc.web_vpc.id
    cidr_block          = "${var.cidr_block["cidr_web2"]}"
    availability_zone   = var.az["c"]
    map_public_ip_on_launch = false
    tags = {
        Name = "web_subnet2"
    }
}

# db subnet 생성
resource "aws_subnet" "db_subnet" {
    vpc_id              = aws_vpc.web_vpc.id
    cidr_block          = "${var.cidr_block["cidr_db"]}"
    availability_zone   = var.az["a"]
    map_public_ip_on_launch = false
    tags = {
        Name = "db_subnet"
    }
}

# db subnet 생성
resource "aws_subnet" "db_subnet2" {
    vpc_id              = aws_vpc.web_vpc.id
    cidr_block          = "${var.cidr_block["cidr_db2"]}"
    availability_zone   = var.az["c"]
    map_public_ip_on_launch = false
    tags = {
        Name = "db_subnet2"
    }
}


# Internet Gatewat 생성
resource "aws_internet_gateway" "web_IGW" {
  vpc_id = aws_vpc.web_vpc.id

  tags = {
    Name = "web_IGW"
  }
}

# eip 생성
resource "aws_eip" "web-eip" {
    vpc      = true
    tags = {
        Name = "web-eip"
  }
}


# NAT 게이트웨이 생성
resource "aws_nat_gateway" "web-NAT" {
  allocation_id = aws_eip.web-eip.id
  subnet_id     = aws_subnet.public_subnet.id
 
  tags = {
    Name = "web-NAT"
  }
}



# public subnet 라우팅
resource "aws_route_table" "public-route" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "${var.cidr_block["cidr_all"]}"
    gateway_id = aws_internet_gateway.web_IGW.id
  }


  tags = {
    Name = "public-route"
  }
}


# private subnet 라우팅
resource "aws_route_table" "private-route" {
  vpc_id = aws_vpc.web_vpc.id

  route {
    cidr_block = "${var.cidr_block["cidr_all"]}"
    nat_gateway_id = aws_nat_gateway.web-NAT.id
  }


  tags = {
    Name = "private-route"
  }
}

# 라우팅 테이블에 public subnet 추가
resource "aws_route_table_association" "public-route-subnet" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public-route.id
}

resource "aws_route_table_association" "public-route-subnet1" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-route.id
}

# 라우팅 테이블에 private subnet 추가
resource "aws_route_table_association" "private-route" {
  subnet_id      = aws_subnet.web_subnet.id
  route_table_id = aws_route_table.private-route.id
}
resource "aws_route_table_association" "private-route1" {
  subnet_id      = aws_subnet.web_subnet2.id
  route_table_id = aws_route_table.private-route.id
}
resource "aws_route_table_association" "private-route2" {
  subnet_id      = aws_subnet.db_subnet.id
  route_table_id = aws_route_table.private-route.id
}
  resource "aws_route_table_association" "private-route3" {
  subnet_id      = aws_subnet.db_subnet.id
  route_table_id = aws_route_table.private-route.id
}


# bastion-sg 생성
resource "aws_security_group" "terraform-bastion-sg" {
    vpc_id              = "${aws_vpc.web_vpc.id}"
    name                = "terraform-bastion-sg"
    tags = {
        Name            = "terraform-bastion-sg"
    }
}

# External-ELB-sg 생성
resource "aws_security_group" "terraform-External-ELB-sg" {
    vpc_id              = "${aws_vpc.web_vpc.id}"
    name                = "terraform-External-ELB-sg"
    tags = {
        Name            = "terraform-External-ELB-sg"
            }
}

# web-sg 생성
resource "aws_security_group" "terraform-web-sg" {
    vpc_id              = "${aws_vpc.web_vpc.id}"
    name                = "terraform-web-sg"
    tags = {
        Name            = "terraform-web-sg"
    }
}



# db-sg 생성
    resource "aws_security_group" "terraform-db-sg" {
    vpc_id              = "${aws_vpc.web_vpc.id}"
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





# terraform-db-sg 인바운드 규칙 추가
resource "aws_security_group_rule" "terraform-db-sg-role" {
    type                = "ingress"
    from_port           = 3306
    to_port             = 3306
    protocol            = "tcp"
    cidr_blocks         = ["0.0.0.0/0"]

        security_group_id   = "${aws_security_group.terraform-db-sg.id}"
}


# terraform-db-sg 아웃바운드 규칙 추가
resource "aws_security_group_rule" "terraform-db-sg-role1" {
    type                = "egress"
    from_port           = 0
    to_port             = 0
    protocol            = "-1"
    cidr_blocks         = ["0.0.0.0/0"]

    security_group_id   = "${aws_security_group.terraform-db-sg.id}"
}





resource "aws_s3_bucket" "terraform-bucket" {
  bucket = "terraform-bucket"
  acl    = "private"

  tags = {
    Name        = "terraform-bucket"
  }
}



resource "aws_s3_bucket_public_access_block" "example-potato" {
  bucket = aws_s3_bucket.terraform-bucket-potato.id

  block_public_acls   = false
  block_public_policy = false
  
}