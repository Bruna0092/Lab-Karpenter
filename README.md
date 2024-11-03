# Lab-Karpenter
Karpenter com Terraform

#Para realizar a criação da VPC
terraform plan -target=module.vpc -var-file="main.tfvars"
terraform apply -target=module.vpc -var-file="main.tfvars"

#Para realizar a criação do cluster
terraform plan -target=module.eks -var-file="main.tfvars"
terraform apply -target=module.eks -var-file="main.tfvars"

#Para criar o provisioner
kubectl apply -f modules/eks/karpenter/provisioner.yaml


#EC2 Spot Linked Role
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com 2> /dev/null || echo 'Already exist'

Passo a passo detalhado: https://archive.eksworkshop.com/beginner/085_scaling_karpenter/setup_the_environment/
