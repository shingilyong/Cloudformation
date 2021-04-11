variable "region" {
    default = "ap-northeast-2"
}

variable "image_id" {
    type = string
    default = "ami-081511b9e3af53902"
}


variable "cidr_block" {
    type = map
    default = {
        cidr_all = "0.0.0.0/0"
        cidr_vpc = "10.0.0.0/16"
        cidr_public = "10.0.0.0/24"
        cidr_public2 = "10.0.10.0/24"
        cidr_web = "10.0.1.0/24"
        cidr_web2 = "10.0.11.0/24"
        cidr_db = "10.0.2.0/24"
        cidr_db2 = "10.0.12.0/24"
    }
}


variable "az" {
    type = map
    default = {
        a = "ap-northeast-2a"
        c = "ap-northeast-2c"
    }
}

