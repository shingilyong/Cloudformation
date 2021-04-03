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