### outputs start ###

output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

### 4 pub subnets ###

output "subnet_pub_2a_id" {
  value = aws_subnet.my-pub_2a.id
}
output "subnet_pub_2b_id" {
  value = aws_subnet.my-pub_2b.id
}
output "subnet_pub_2c_id" {
  value = aws_subnet.my-pub_2c.id
}
output "subnet_pub_2d_id" {
  value = aws_subnet.my-pub_2d.id
}

### 4 pvt subnets ###
output "subnet_pvt_2a_id" {
  value = aws_subnet.my-pvt_2a.id
}
output "subnet_pvt_2b_id" {
  value = aws_subnet.my-pvt_2b.id
}
output "subnet_pvt_2c_id" {
  value = aws_subnet.my-pvt_2c.id
}
output "subnet_pvt_2d_id" {
  value = aws_subnet.my-pvt_2d.id
}

### list pvt subnets ###
output "subnet_pvt_2a_ids" {
  value = aws_subnet.my-pvt_2a[*].id
}
output "subnet_pvt_2c_ids" {
  value = aws_subnet.my-pvt_2c[*].id
}


### terraform-sg-web ###
output "sg_id" {
  value = aws_security_group.terraform_sg.id
}

### outputs end ###
