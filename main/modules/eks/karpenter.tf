################################################################################################################

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "karpenter_controller_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:karpenter:karpenter"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "karpenter_controller" {
  assume_role_policy = data.aws_iam_policy_document.karpenter_controller_assume_role_policy.json
  name               = "karpenter-controller-role"
}

resource "aws_iam_policy" "karpenter_controller" {
  policy = file("${path.module}/policy/controller-trust-policy.json")
  name   = "Karpenter-controller-policy"
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller_attach" {
  role       = aws_iam_role.karpenter_controller.name
  policy_arn = aws_iam_policy.karpenter_controller.arn
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "Karpenter-Node-InstanceProfile"
  role = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "eks_node_attach_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.karpenter_controller.name
}

resource "aws_iam_role_policy_attachment" "eks_node_attach_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.karpenter_controller.name
}

resource "aws_iam_role_policy_attachment" "eks_node_attach_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.karpenter_controller.name
}

########################################################################################################
resource "aws_sqs_queue" "karpenter" {
  message_retention_seconds = 300
  name                      = "${var.cluster_name}-sqs"
}

data "aws_iam_policy_document" "node_termination_queue" {
  statement {
    resources = [aws_sqs_queue.karpenter.arn]
    sid       = "SQSWrite"
    actions   = ["sqs:SendMessage"]
    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com", "sqs.amazonaws.com"]
    }
  }
}

resource "aws_sqs_queue_policy" "karpenter" {
  policy    = data.aws_iam_policy_document.node_termination_queue.json
  queue_url = aws_sqs_queue.karpenter.url
}

########################################################################################################

resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "1.0.7"

  values = [
    "${file("${path.module}/values/values.yaml")}"
  ]

  wait_for_jobs = true

  # set {
  #   name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   value = aws_iam_role.karpenter_controller.arn
  # }

  # set {
  #   name  = "settings.clusterName"
  #   value = aws_eks_cluster.cluster.id
  # }

  # set {
  #   name  = "settings.interruptionQueue"
  #   value = aws_sqs_queue.karpenter.name
  # }

  # set {
  #   name  = "aws.defaultInstanceProfile"
  #   value = aws_iam_instance_profile.karpenter.name
  # }

  # set {
  #   name = "replicas"
  #   value = "1"
  # }

  # set {
  #   name  = "nodeSelector.use"
  #   value = "management"
  # }

  # set {
  #   name = "tolerations"
  #   value = "[]"
  # }

  depends_on = [aws_eks_node_group.node-group-management]
}