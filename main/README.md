# Arquivos Terraform para provisionar toda a infraestrutura necessária para o lab

Ajuste o arquivo 'main.tfvars' para alterar a versão e o nome do cluster EKS.

Diretório 'modules' contem os arquivos para criação da VPC e EKS.

Diretório 'main/modules/eks/values' contém os valores do helm para deploy do karpenter, realize ajustes caso necessário.

Diretório 'main/modules/eks/configs', json com as configurações do addon CoreDNS, o objetivo é especificar através do NodeSelector o nó de gerenciamento onde ele irá rodar.
