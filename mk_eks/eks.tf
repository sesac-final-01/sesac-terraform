### ref mk_vpc/vpc.tf  ###
# data "terraform_remote_state" "vpc" {
#   backend = "s3"

#   config = {
#     path = "../mk_vpc/terraform.tfstate"
#   }
# }

data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.s3_bucket_name
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}

#  1. EKS Cluster IAM Role

resource "aws_iam_role" "eks_cluster_iam_role" {
  name               = "awos-eks-cluster-iam-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# 2. IAM Role policy 

resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_iam_role.name
}

# 3. EKS Cluster

resource "aws_eks_cluster" "my_eks_cluster" {
  name     = "awos-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_iam_role.arn
  version  = "1.29"
  vpc_config {
    security_group_ids = [data.terraform_remote_state.vpc.outputs.sg_id]
    # private subnet 사용, nat-instance 생성해야함
    # 두 개 이상 배열 결합, [*]는 해당 데이터 소스로부터 반환된 모든 요소를 나열하도록 Terraform에 지시합니다.
    subnet_ids              = concat(data.terraform_remote_state.vpc.outputs.subnet_pvt_2a_ids, data.terraform_remote_state.vpc.outputs.subnet_pvt_2c_ids)
    endpoint_private_access = true # 동일 vpc 내 private ip간 통신허용
    endpoint_public_access  = true # gcp 에서 접근할 수 있도록 설정
  }
}

# 4. Node Group IAM Role
# 단순 role 을 생성
resource "aws_iam_role" "eks_node_iam_role" {
  name               = "awos-eks-node-iam-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# iam role policy
# 생성한 역할 eks_node_iam_role에 3가지 정책(AmazonEKSWorkerNodePolicy, 
#   AmazonEKS_CNI_Policy, AmazonEC2ContainerRegistryReadOnly)을 부여
resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_iam_role.name
}

# pod 네트워크인 컨테이너 네트워크 인터페이스(flannerl, calico)를 사용하기 위함
resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node_iam_role.name
}

# ecr로부터 이미지를 가져오게끔 하는 역할
resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_iam_role.name
}

# 5. EKS Node Group

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name = aws_eks_cluster.my_eks_cluster.name
  # 클러스터가 다 다르기 때문에 노드 그룹의 이름이 같아도 상관없음
  node_group_name = "worker-node-group"
  node_role_arn   = aws_iam_role.eks_node_iam_role.arn
  subnet_ids      = concat(data.terraform_remote_state.vpc.outputs.subnet_pvt_2a_ids, data.terraform_remote_state.vpc.outputs.subnet_pvt_2c_ids)
  instance_types  = ["t2.micro"]
  capacity_type   = "ON_DEMAND"
  remote_access {
    # 보안을 강화하기 위해서 eks 노드 그룹에 접근할 수 있는 인스턴스들은 
    # my_sg_web에 포함이 되어 있는 인스턴스들만 접근이 가능하게끔 함
    # ec2_ssh_key = "sesac-key"
    ec2_ssh_key = "sesac-key-virginia"
  }
  labels = {
    "role" = "eks_node_iam_role"
  }
  scaling_config {
    desired_size = 2
    min_size     = 2
    max_size     = 4
  }
  # ec2 workernode 를 생성할 때 태그로 식별
  tags = {
    Name = "awos-worker"
  }
  depends_on = [
    # eks 서비스를 사용하기 위한 3가지의 정책
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}

