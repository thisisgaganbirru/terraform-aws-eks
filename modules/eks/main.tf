resource "aws_security_group" "eks_cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-cluster-sg"
  }
}

resource "aws_security_group" "eks_nodes" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.eks_cluster.id]
  }

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-node-sg"
  }
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.eks_cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = [ "api", "audit", "authenticator", "controllerManager", "scheduler" ]

  tags = {
    Name = var.cluster_name
  }

  depends_on = [aws_security_group.eks_cluster]
}

resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-node-group"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids

  instance_types = [var.node_instance_type]

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name = "${var.cluster_name}-node-group"
  }

  depends_on = [aws_eks_cluster.main]
}

data "tls_certificate" "eks_cluster" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks_cluster" {
  client_id_list = [ "sts.amazonaws.com" ]
  thumbprint_list = [ data.tls_certificate.eks_cluster.certificates[0].sha1_fingerprint ]
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = {
    Name = "${var.cluster_name}-irsa"
  }
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.main.name
  addon_name = "coredns"

  depends_on = [ aws_eks_node_group.main ]
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name = aws_eks_cluster.main.name
  addon_name = "kube-proxy"

  depends_on = [ aws_eks_node_group.main ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = aws_eks_cluster.main.name
  addon_name = "vpc-cni"

  depends_on = [ aws_eks_node_group.main ]
  
}

resource "aws_eks_node_group" "spot" {
  cluster_name = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-spot"
  node_role_arn = var.node_role_arn
  subnet_ids = var.subnet_ids

  capacity_type = "SPOT"
  instance_types = [ "t3.medium", "t3.large", "t3a.medium" ]

  scaling_config {
    desired_size = var.spot_desired_size
    min_size = var.spot_min_size
    max_size = var.spot_max_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "spot"
    env = var.environment
  }

  tags = {
    Name = "${var.cluster_name}-spot"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled" = "true"
  }

  depends_on = [ aws_eks_cluster.main ]
}

resource "aws_eks_node_group" "system" {
  cluster_name = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-system"
  node_role_arn = var.node_role_arn
  subnet_ids = var.subnet_ids

  capacity_type = "ON_DEMAND"
  instance_types = [ "t3.medium" ]

  scaling_config {
    desired_size = 2
    min_size = 2
    max_size = 2
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "system"
    env = var.environment
  }
  
  taint {
    key = "CriticalAddonsOnly"
    value = "true"
    effect = "NO_SCHEDULE"
  }

  tags = {
    Name = "${var.cluster_name}-system"
  }
  
  depends_on = [ aws_eks_cluster.main ]
}