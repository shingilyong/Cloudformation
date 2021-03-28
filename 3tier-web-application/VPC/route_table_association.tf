
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


