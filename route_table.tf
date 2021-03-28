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
    gateway_id = aws_nat_gateway.terraform-NAT.id
  }

  tags = {
    Name = "terraform-private-route"
  }
}