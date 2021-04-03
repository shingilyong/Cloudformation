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