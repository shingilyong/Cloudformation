terraform {
  backend "s3" {
    bucket = "sgy-bucket"
    key = "terraform/terraform.tfstate"
    region = "ap-northeast-2"
    dynamodb_table = "gy-terraform-lock"
    
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# resource "aws_s3_bucket" "tfstate" {
#     bucket = "sgy-bucket"

#     versioning {
#       enabled = true
#     }
# }

# resource "aws_dynamodb_table" "terraform_state_lock" {
#     name = "gy-terraform-lock"
#     hash_key = "LockID"
#     billing_mode = "PAY_PER_REQUEST"

#     attribute {
#       name = "LockID"
#       type = "S"
#     }
  
# }






module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "gy-vpc"
  cidr = "10.0.0.0/16"
  enable_nat_gateway  = true
  single_nat_gateway = true

  azs             = [var.azs[0], var.azs[1]]
  private_subnets = [var.priv_subnet[0], var.priv_subnet[1]]
  public_subnets  = [var.pub_subnet[0], var.pub_subnet[1]]


  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}



resource "aws_security_group" "bastion_sg" {
  name        = "gy-bastion"
  description = "bastion"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "gy-bastion"
  }
}

resource "aws_security_group" "eks_sg" {
  name        = "gy-eks"
  description = "gy-eks"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = ""
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "gy-eks"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "gy-key"
  public_key = file("/Users/Shin/.ssh/id_rsa.pub")
}


resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  availability_zone      = var.azs[0]
  subnet_id              = module.vpc.public_subnets[0]
  vpc_security_group_ids = ["${aws_security_group.bastion_sg.id}"]
  key_name               = var.key_pair
  user_data              = "${file("install.sh")}"

  tags = {
    Name = "gy-bastion"
  }

}

resource "aws_eip" "eip" {
  vpc      = true
  instance = aws_instance.bastion.id
  tags = {
    "Name" = "gy-eip"
  }
}

resource "aws_ami_from_instance" "ami" {
  name               = "gy-ami"
  source_instance_id = aws_instance.bastion.id

}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0"

  cluster_name                    = "gy-eks"
  cluster_version                 = "1.24"
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }


  create_iam_role = true
  iam_role_arn    = false
  iam_role_name   = "gy-eks-role"

  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  cluster_security_group_id =  aws_security_group.eks_sg.id

  eks_managed_node_group_defaults = {
    instance_types = "t2.medium"
  }

  eks_managed_node_groups = {
    gy-eks = {
        min_size = 1
         desired_size = 1
        instance_types = ["t2.medium"]
        key_name = "${var.key_pair}"
        vpc_security_group_ids = ["${aws_security_group.eks_sg.id}"]
    }

}
}