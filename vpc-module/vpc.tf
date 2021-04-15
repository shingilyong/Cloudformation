provider "aws" {
    region = "ap-northeast-2"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" #사용할 Module 지정
  version = "2.78.0"                        #Module 버전 지정


  name = "vpc"                              #VPC 이름 지정
  cidr = "192.168.0.0/16"                      #IPv4 CIDR

  azs             = ["ap-northeast-2a", "ap-northeast-2c"] #가용영역 지정
  public_subnets  = ["192.168.10.0/24", "192.168.20.0/24"]  #퍼블릭 서브넷
  private_subnets = ["192.168.11.0/24", "192.168.21.0/24"] #프라이빗 서브넷
  database_subnets = ["192.168.12.0/24", "192.168.22.0/24"] #데이터베이스 서브넷
 
  enable_nat_gateway = true			#NAT Gateway 활성
  single_nat_gateway = true         #단일 NAT Gateway 설정
  one_nat_gateway_per_az = false    #단일 NAT 설정 시 false로 비활성화
  
  
  create_database_subnet_group            = true    #RDS용 서브넷 구성
  create_database_subnet_route_table      = true    #RDS용 서브넷의 라우팅 테이블 구성
  create_database_internet_gateway_route  = true    #RDS용 라우팅 테이블에 인터넷 게이트웨이 연결 설정 여부

  enable_dns_hostnames = "true"  #DNS Hostname Enable
  enable_dns_support    = "true"   #DNS Support Enable

  tags = { "TerraformManaged" = "true" }                   #태그 설정
}
