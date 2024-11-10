resource "aws_security_group" "eks_default_sg_nodes" {
  name        = "eks_default_sg_nodes"
  description = "Default SG EKS Karpenter"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    self             = true
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name                        = "eks_default_sg_nodes"
    "karpenter.sh/discovery"    = "${var.cluster_name}"
  }
}