resource "aws_internet_gateway" "terraform_IGW" {
  vpc_id = aws_vpc.terraform_test.id

  tags = {
    Name = "terraform_IGW"
  }
}