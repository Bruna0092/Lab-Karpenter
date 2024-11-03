provider "kubernetes" {
  host                   = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapUsers = jsonencode([
      {
        userarn  = "arn:aws:iam::451821666126:user/iac_user"
        username = "iac_user"
        groups   = ["system:masters"]
      }
    ])
    mapRoles = jsonencode([
      {
        rolearn  = "arn:aws:iam::451821666126:role/eks-node-group"
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = ["system:bootstrappers", "system:nodes"]
      }
    ])
  }

  depends_on = [aws_eks_cluster.cluster]
}
