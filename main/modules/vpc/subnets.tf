resource "aws_subnet" "eks-public-us-east-1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "eks-public-us-east-1a"
    "karpenter.sh/discovery"                    = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_subnet" "eks-public-us-east-1b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "eks-public-us-east-1b"
    "karpenter.sh/discovery"                    = "${var.cluster_name}"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}