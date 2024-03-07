## 공통 사항

- 기본적으로 s3 버킷에 terraform.tfstate 파일이 생성됩니다.
  s3에서 terraform init, terraform plan, apply 를 진행 후에
  하시면 각 디렉토리 내에서 init, plan, apply를 진행하시면 됩니다.

- 안되면 찾아볼것

## VPC

- VPC CIDR 대역은 10.162.0.0/16, 커스터마이징이 필요할 경우 variable.tf 파일에서 변경하시면 됩니다.

## EC2

- s3버킷의 vpc/terraform.tfstate를 참조하여 만듭니다.
- ec2에서 만들어진 terraform.tfstate 는 s3 버킷 내의 ec2/terraform.tfstate 로 관리되어집니다.

# EKS

- s3버킷의 vpc/terraform.tfstate를 참조하여 만듭니다.
- eks에서 만들어진 terraform.tfstate 는 s3 버킷 내의 eks/terraform.tfstate 로 관리되어집니다.
