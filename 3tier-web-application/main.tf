provider "aws" {

    region     = "ap-northeast-2"
}

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

# Internet Gatewat 생성
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



# public subnet 라우팅
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

# private subnet 라우팅
resource "aws_route_table" "terraform-private-route" {
  vpc_id = aws_vpc.terraform_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraform-NAT.id
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


## Key pair 생성
resource "aws_key_pair" "terraform_key" {
  key_name = "terraform_key"
  public_key = "${file("~/.ssh/public/id_rsa.pub")}"
}

## Key pair 생성
resource "aws_key_pair" "private_key" {
  key_name = "private_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}


# bastion 인스턴스 생성
resource "aws_instance" "terraform-bastion" {
  ami                       = "ami-081511b9e3af53902"
  instance_type             = "t2.micro"
    subnet_id                 = "${aws_subnet.terraform-public-1.id}"
  vpc_security_group_ids    = ["${aws_security_group.terraform-bastion-sg.id}"
]
  key_name                  = "${aws_key_pair.terraform_key.key_name}"

  associate_public_ip_address = true

  tags = {
    Name = "terraform-bastion"
  }
}

# Web1 인스턴스 생성
resource "aws_instance" "terraform-web-1" {
  ami                       = "ami-081511b9e3af53902"
  instance_type             = "t2.micro"
  user_data                 = "${file("web-data.sh")}"
  subnet_id                 = "${aws_subnet.terraform-web-1.id}"
  vpc_security_group_ids    = ["${aws_security_group.terraform-web-sg.id}"]
  key_name                  = "${aws_key_pair.private_key.key_name}"


  associate_public_ip_address = false

  tags = {
    Name = "terraform-web-1"
  }
}

# web2 인스턴스 생성
resource "aws_instance" "terraform-web-2" {
  ami                       = "ami-081511b9e3af53902"
  instance_type             = "t2.micro"
  subnet_id                 = "${aws_subnet.terraform-web-2.id}"
  vpc_security_group_ids    = ["${aws_security_group.terraform-web-sg.id}"]
  key_name                  = "${aws_key_pair.private_key.key_name}"
  user_data                 = "${file("web-data2.sh")}"

  associate_public_ip_address = false

  tags = {
    Name = "terraform-web-2"
  }
}


# was1 인스턴스 생성
resource "aws_instance" "terraform-was-1" {
  ami                       = "ami-081511b9e3af53902"
  instance_type             = "t2.micro"
  subnet_id                 = "${aws_subnet.terraform-was-1.id}"
  vpc_security_group_ids    = ["${aws_security_group.terraform-was-sg.id}"]
  user_data                 = "${file("was-data.sh")}"
  key_name                  = "${aws_key_pair.private_key.key_name}"


  associate_public_ip_address = false

  tags = {
    Name = "terraform-was-1"
      }
}

# was2 인스턴스 생성
resource "aws_instance" "terraform-was-2" {
  ami                       = "ami-081511b9e3af53902"
  instance_type             = "t2.micro"
  subnet_id                 = "${aws_subnet.terraform-was-2.id}"
  vpc_security_group_ids    = ["${aws_security_group.terraform-was-sg.id}"]
  user_data                 = "${file("was-data2.sh")}"
  key_name                  = "${aws_key_pair.private_key.key_name}"


  associate_public_ip_address = false

  tags = {
    Name = "terraform-was-2"
  }
}

# External-ELB 생성
resource "aws_lb" "terraform-external-elb" {
  name               = "terraform-external-elb"
  subnets = ["${aws_subnet.terraform-public-1.id}", "${aws_subnet.terraform-public-2.id}"]
  security_groups    = ["${aws_security_group.terraform-External-ELB-sg.id}"]
  load_balancer_type = "application"

  tags = {
    Name = "terraform-external-elb"
      }
}

# target group 생성
resource "aws_lb_target_group" "terraform-tg" {
  name     = "terraform-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id

  health_check {
  interval            = 30
  path                = "/"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  }
}

# 타겟 그룹에 타겟 설정
resource "aws_lb_target_group_attachment" "terraform-tg-attach" {
  target_group_arn = aws_lb_target_group.terraform-tg.arn
  target_id        = "${aws_instance.terraform-web-1.id}"
  port             = 80
 }

 resource "aws_lb_target_group_attachment" "terraform-tg-attach2" {
  target_group_arn = aws_lb_target_group.terraform-tg.arn
  target_id        = "${aws_instance.terraform-web-2.id}"
  port             = 80

   }


# alb 리스너 설정
resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_lb.terraform-external-elb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.terraform-tg.arn}"
    type             = "forward"
  }
}





# Internal-ELB 생성
resource "aws_lb" "terraform-internal-elb" {
  name               = "terraform-internal-elb"
  subnets = ["${aws_subnet.terraform-was-1.id}", "${aws_subnet.terraform-was-2
.id}"]
  security_groups    = ["${aws_security_group.terraform-Internal-ELB-sg.id}"]
  load_balancer_type = "application"
  internal           = true 

  tags = {
    Name = "terraform-internal-elb"
  }

  }

# target group 생성
resource "aws_lb_target_group" "terraform-tg-1" {
  name     = "terraform-tg-1"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.terraform_vpc.id

  health_check {
  interval            = 30
  path                = "/"
  healthy_threshold   = 3
  unhealthy_threshold = 3
  }
}

# 타겟 그룹에 타겟 설정
resource "aws_lb_target_group_attachment" "terraform-tg-attach3" {
  target_group_arn = aws_lb_target_group.terraform-tg-1.arn
  target_id        = "${aws_instance.terraform-was-1.id}"
  port             = 8080
 }

 resource "aws_lb_target_group_attachment" "terraform-tg-attach4" {
  target_group_arn = aws_lb_target_group.terraform-tg-1.arn
  target_id        = "${aws_instance.terraform-was-2.id}"
  port             = 8080
 }

 # alb 리스너 설정
resource "aws_alb_listener" "was" {
  load_balancer_arn = "${aws_lb.terraform-internal-elb.arn}"
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_lb_target_group.terraform-tg-1.arn}"
    type             = "forward"
  }
}



# Subnet group 생성
resource "aws_db_subnet_group" "terraform-subnet-group" {
  name       = "terraform-subnet-group"
  subnet_ids = [aws_subnet.terraform-db-1.id, aws_subnet.terraform-db-2.id]

  tags = {
    Name = "terraform-subnet-group"
  }
}


# RDS DB Instance 생성
resource "aws_db_instance" "terraform-DB" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "8.0.20"
  instance_class       = "db.t2.micro"
  name                 = "terraformDB"
  username             = "admin"
  password             = "qwer1234"
  identifier           = "terraform-db"
  skip_final_snapshot  = true
  db_subnet_group_name  = "terraform-subnet-group"
  vpc_security_group_ids = ["${aws_security_group.terraform-db-sg.id}"]
  multi_az             = true
}