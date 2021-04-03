
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