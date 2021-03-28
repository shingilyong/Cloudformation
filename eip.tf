resource "aws_eip" "terraform-NAT-eip" {   
    vpc      = true
    tags = {
        Name = "terraform-NAT-eip"
  }
}