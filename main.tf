# Creating VPC
resource "aws_vpc" "myvpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_tag_name
  }
}

#Creating Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = var.igw_tag_name
  }

}

#Creating Subnets
resource "aws_subnet" "dev" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.dev_cidr
  availability_zone       = var.dev_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.dev_tag_name
  }
}

resource "aws_subnet" "prod" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = var.prod_cidr
  availability_zone       = var.prod_availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = var.prod_tag_name
  }
}



#Creating Route Tables
resource "aws_route_table" "public-RT" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = var.rt_tag_name
  }
  route {
    cidr_block = var.public_cidr
    gateway_id = aws_internet_gateway.igw.id
  }
}

#Creating Subnet Association
resource "aws_route_table_association" "public-rta1" {
  subnet_id      = aws_subnet.dev.id
  route_table_id = aws_route_table.public-RT.id
}

resource "aws_route_table_association" "public-rta2" {
  subnet_id      = aws_subnet.prod.id
  route_table_id = aws_route_table.public-RT.id
}

#Creating Security Groups
resource "aws_security_group" "webSg" {
  name   = var.sg_name
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = var.http_description
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidrs
  }
  ingress {
    description = var.ssh_description
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = var.eg_protocal
    cidr_blocks = var.allowed_cidrs
  }

  tags = {
    Name = var.sg_tag_name
  }
}

# Creating S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = var.bucket
}

# Creating Ec2-instance with the VPC
resource "aws_instance" "webserver1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.dev.id
  user_data              = filebase64(var.user_data)
  tags = {
    Name = var.web1_tag_name
  }
}

resource "aws_instance" "webserver2" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.prod.id
  user_data              = filebase64(var.user_data)
  tags = {
    Name = var.web2_tag_name
  }
}

#create alb
resource "aws_lb" "myalb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = var.alb_type

  security_groups = [aws_security_group.webSg.id]
  subnets         = [aws_subnet.dev.id, aws_subnet.prod.id]

  tags = {
    Name = var.alb_tag_name
  }
}

# Creating target Group
resource "aws_lb_target_group" "tg" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = aws_vpc.myvpc.id

  health_check {
    path = var.tg_health_check_path
    port = var.tg_health_check_port
  }
}

# Attaching Load Balancer
resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = var.attach_port
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = var.attach_port
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = var.listener_port
  protocol          = var.listener_protocol

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}


