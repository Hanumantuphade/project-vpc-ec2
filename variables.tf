
# VPC variables
variable "vpc_cidr" {
  type = string
}
variable "vpc_tag_name" {
  type = string
}

#internet getway
variable "igw_tag_name" {
  type = string
}

# Dev subnet variables
variable "dev_cidr" {
  type = string
}

variable "dev_availability_zone" {
  type = string
}

variable "dev_tag_name" {
  type = string
}



# Prod subnet variables
variable "prod_cidr" {
  type = string
}

variable "prod_availability_zone" {
  type = string
}

variable "prod_tag_name" {
  type = string
}

# Public route table variables
variable "public_cidr" {
  type = string
} 

variable "rt_tag_name" {
  type = string
}

# Security group variables
variable "sg_name" {
  type = string
}

variable "http_description" {
  type = string
}

variable "http_port" {
  type = number
}

variable "ssh_description" {
  type = string
}

variable "ssh_port" {
  type = number
}

variable "protocol" {
  type = string
}

variable "allowed_cidrs" {
  type = list(string)
}

variable "egress_port" {
  type= number
}

variable "eg_protocal" {
  type = string
}

variable "sg_tag_name" {
  type = string
}

# S3 bucket variables
variable "bucket" {
  type = string
}

# EC2 instance variables
variable "ami" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "user_data" {
  type = string
}

variable "web1_tag_name" {
  type = string
}

variable "web2_tag_name" {
  type = string
}


# Application Load Balancer variables
variable "alb_name" {
  type = string
}

variable "alb_type" {
  type = string
}

variable "alb_tag_name" {
  type = string
}

# Target group variables
variable "tg_name" {
  type = string
}

variable "tg_port" {
  type = number
}

variable "tg_protocol" {
  type = string
}

variable "tg_health_check_path" {
  type = string
}

variable "tg_health_check_port" {
  type = string
}

# Target group attachment variables
variable "attach_port" {
  type = number
}

# Listener variables
variable "listener_port" {
  type = number
}

variable "listener_protocol" {
  type = string
}
