data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.s3_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

# data "terraform_vpc" "my_vpc" {
#   vpc = ["my-terraform-vpc"]
# }

# module "vpc" {
#   source = "../mk_vpc"
# }


### ec2 start ###

# resource "aws_instance" "AL2-jenkins-server" {
#   ami                    = "ami-0431de406636a213f"
#   instance_type          = "t3.small"
#   subnet_id              = module.vpc.subnet_pub_2a_id
#   vpc_security_group_ids = [module.vpc.sg_id]
#   key_name               = "sesac-key"
#   #  user_data              = file("user-data-jenkins.sh")

#   tags = {
#     Name = "final-jenkins"
#   }
# }

# resource "aws_instance" "AL2-jenkins-server" {
#   ami                    = "ami-0431de406636a213f"
#   instance_type          = "t3.small"
#   subnet_id              = data.terraform_remote_state.vpc.outputs.subnet_pub_2a_id
#   vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg_id]
#   key_name               = "sesac-key"
#   #  user_data              = file("user-data-jenkins.sh")

#   tags = {
#     Name = "final-jenkins"
#   }
# }

#resource "aws_instance" "AL2-instance2" {
#  ami                    = "ami-04599ab1182cd7961"
#  instance_type          = "t2.micro"
#  subnet_id              = data.terraform_remote_state.vpc.outputs.subnet_pub_2c_id
#  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg_id]
#  key_name               = "sesac-key"
#  user_data              = file("user-data-jenkins.sh")

#  tags = {
#    Name = "final-instance2"
#  }
#}
# resource "aws_instance" "eks-controller" {
#   ami                    = "ami-04599ab1182cd7961"
#   instance_type          = "t2.micro"
#   subnet_id              = data.terraform_remote_state.vpc.outputs.subnet_pub_2a_id
#   vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg_id]
#   key_name               = "sesac-key"
#   #user_data              = file("user-data-eks-server.sh")

#   tags = {
#     Name = "eks-server"
#   }
# }
resource "aws_instance" "eks-master" {
  # ami                    = "ami-04599ab1182cd7961"
  ami                    = "ami-07761f3ae34c4478d"
  instance_type          = "t2.micro"
  subnet_id              = data.terraform_remote_state.vpc.outputs.subnet_pub_2a_id
  vpc_security_group_ids = [data.terraform_remote_state.vpc.outputs.sg_id]
  key_name               = "sesac-key-virginia"
  user_data              = file("user-data-eks-server.sh")

  tags = {
    Name = "eks-server"
  }
}

### ec2 end ###
