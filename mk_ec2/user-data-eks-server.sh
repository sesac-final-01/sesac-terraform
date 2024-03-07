#!/bin/bash
timedatectl set-timezone Asia/Seoul
hostnamectl set-hostname eks-server
cd /tmp
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install
