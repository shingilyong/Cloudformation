
## Key pair 생성
resource "aws_key_pair" "terraform_key" {
  key_name = "terraform_key"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}

# bastion 인스턴스 생성
resource "aws_instance" "terraform-bastion" {
  ami                       = "ami-081511b9e3af53902"
  instance_type             = "t2.micro"
  subnet_id                 = "${aws_subnet.terraform-public-1.id}"
  vpc_security_group_ids    = ["${aws_security_group.terraform-bastion-sg.id}"]
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
  subnet_id                 = "${aws_subnet.terraform-web-1.id}"
  vpc_security_group_ids    = ["${aws_security_group.terraform-web-sg.id}"]

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

  associate_public_ip_address = false

  tags = {
    Name = "terraform-was-2"
  }
}