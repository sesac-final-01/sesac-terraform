provider "aws" {
  region = "us-east-1"
}

### vpc start ###

resource "aws_vpc" "my_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true      # 기본값은 true 라 안넣어줘도됨
  instance_tenancy     = "default" # default 는 공유 테넌시

  tags = {
    Name = "my-terraform-vpc"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "my-pub_2a" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnets_cidr[0]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0] # ap-northeast-2a
  tags = {
    Name = "my-pub-2a"
  }
}

resource "aws_subnet" "my-pub_2b" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnets_cidr[1]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1] # ap-northeast-2b
  tags = {
    Name = "my-pub-2b"
  }
}

resource "aws_subnet" "my-pub_2c" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnets_cidr[2]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[2] # ap-northeast-2c
  tags = {
    Name = "my-pub-2c"
  }
}

resource "aws_subnet" "my-pub_2d" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.public_subnets_cidr[3]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[3] # ap-northeast-2d
  tags = {
    Name = "my-pub-2d"
  }
}

resource "aws_subnet" "my-pvt_2a" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets_cidr[0]
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "my-pvt-2a"
  }
}

resource "aws_subnet" "my-pvt_2b" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets_cidr[1]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "my-pvt-2b"
  }
}

resource "aws_subnet" "my-pvt_2c" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets_cidr[2]
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "my-pvt-2c"
  }
}

resource "aws_subnet" "my-pvt_2d" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnets_cidr[3]
  availability_zone = data.aws_availability_zones.available.names[3]
  tags = {
    Name = "my-pvt-2d"
  }
}

### IGW ###
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-igw"
  }
}

## NGW ###
#eip; elastic IP
resource "aws_eip" "ngw" {
}

#nat gateway는 public subnet에 존재, a와c 가용영역에 위치중이니 d에도 넣어보자
resource "aws_nat_gateway" "my_ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.my-pub_2c.id
  tags = {
    Name = "final-ngw"
  }
}

### 
resource "aws_route_table" "my_pub_rtb" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    # 목적지(destination)
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
  tags = {
    Name = "my-pub-rtb"
  }
}

resource "aws_route_table" "my_pvt_rtb" {
  vpc_id = aws_vpc.my_vpc.id
  route {
    # 내부 아이피를 제외한 모든 아이피는 nat gateway로 가라
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.my_ngw.id
  }

  tags = {
    Name = "my-pvt-rtb"
  }
}

resource "aws_route_table_association" "my-pub_2a_association" {
  subnet_id      = aws_subnet.my-pub_2a.id
  route_table_id = aws_route_table.my_pub_rtb.id
}

resource "aws_route_table_association" "my-pub_2b_association" {
  subnet_id      = aws_subnet.my-pub_2b.id
  route_table_id = aws_route_table.my_pub_rtb.id
}

resource "aws_route_table_association" "my-pub_2c_association" {
  subnet_id      = aws_subnet.my-pub_2c.id
  route_table_id = aws_route_table.my_pub_rtb.id
}

resource "aws_route_table_association" "my-pub_2d_association" {
  subnet_id      = aws_subnet.my-pub_2d.id
  route_table_id = aws_route_table.my_pub_rtb.id
}

resource "aws_route_table_association" "my-pvt_2a_association" {
  subnet_id      = aws_subnet.my-pvt_2a.id
  route_table_id = aws_route_table.my_pvt_rtb.id
}

resource "aws_route_table_association" "my-pvt_2b_association" {
  subnet_id      = aws_subnet.my-pvt_2b.id
  route_table_id = aws_route_table.my_pvt_rtb.id
}

resource "aws_route_table_association" "my-pvt_2c_association" {
  subnet_id      = aws_subnet.my-pvt_2c.id
  route_table_id = aws_route_table.my_pvt_rtb.id
}

resource "aws_route_table_association" "my-pvt_2d_association" {
  subnet_id      = aws_subnet.my-pvt_2d.id
  route_table_id = aws_route_table.my_pvt_rtb.id
}

### vpc end ###

### sg-web start ###

resource "aws_security_group" "terraform_sg" {
  vpc_id = aws_vpc.my_vpc.id
  name   = var.security_group_name

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    # icmp는 포트번호가 없기 때문에 -1 로 설정
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "terraform-sg-web"
  }
}

### sg-web end ###
