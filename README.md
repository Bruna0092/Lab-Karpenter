# Lab Karpenter básico

Este lab tem a intenção de demonstrar o funcionamento basico do Karpenter e seu provisionamento "automatico" com o terraform.

## Pré requisitos
- Terraform
- Helm
- Kubectl
- Conta IAM Admin para provisionar os recursos com terraform

## Terraform:
```
cd main
terraform init
```

## Para realizar a criação da VPC:
```
terraform plan -target=module.vpc -var-file="main.tfvars"
terraform apply -target=module.vpc -var-file="main.tfvars"
```

## Para realizar a criação do cluster EKS:
```
terraform plan -target=module.eks -var-file="main.tfvars"
terraform apply -target=module.eks -var-file="main.tfvars"
```

## Para criar tudo:
```
terraform plan -var-file="main.tfvars"
terraform apply -var-file="main.tfvars"
```

## Criação de uma Service-Linked Role para o serviço AWS Spot:
```
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com --region us-east-1 || true
```

## Obter o acesso ao cluster:
```
aws --profile seu-profile eks update-kubeconfig --region us-east-1 --name cluster-karpenter
```

# Acompanhar os logs do Kerpenter:
```
kubectl -n karpenter logs -l app.kubernetes.io/name=karpenter --all-containers=true -f --tail=20
```

## Instalação do eks-node-viewer, que permite visualizar os nodes do cluster EKS:
```
Link instalação go: https://go.dev/doc/install
link instalação eks-node-viewer: https://github.com/awslabs/eks-node-viewer
Download: wget  https://go.dev/dl/go1.23.3.linux-amd64.tar.gz

sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.23.3.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
source $HOME/.bashrc
go version
go install github.com/awslabs/eks-node-viewer/cmd/eks-node-viewer@latest
alias eks-node-viewer='$HOME/go/bin/eks-node-viewer'

Visualizar CPU e Memoria
eks-node-viewer --resources cpu,memory
```

## Criar o NodePool:
```
kubectl apply -f karpenter-manifestos/NodePool.yaml

# Verifique se esta ready, caso contrario as instancias não serão criadas.
kubectl get ec2nodeclass
```

## Teste - Aplicar a criação do inflate:
```
kubectl apply -f karpenter-manifestos/inflate.yaml
```

## Alterar a quantidade de replicas para aumentar o diminuir os nodes:
```
kubectl scale deployment inflate --replicas=10 -n default
```

## ⚠️⚠️ Remover toda a infra vpc\eks: 
```
terraform destroy -var-file="main.tfvars"
```

## Screenshots

Conforme podemos ver na imagem abaixo, o karpenter escalonou o cluster para atender a demanda:
![Karpenter Scale](https://raw.githubusercontent.com/Bruna0092/Lab-Karpenter/49069f858ec012ca290144d9536c5447b7985f3e/img/karpenter-35-pods.png)

Já aqui, é identificado que as não existe mais a necessidade dos nodes, então as máquinas são automaticamente terminadas:
![Karpenter ScaleDown](https://raw.githubusercontent.com/Bruna0092/Lab-Karpenter/refs/heads/main/img/karpenter-termination-nodes.png)
