resource "aws_eks_node_group" "togglemaster" {
  cluster_name    = aws_eks_cluster.togglemaster.name
  node_group_name = "togglemaster-fase4-ng"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id
  ]

  instance_types = ["t3.large"]
  capacity_type  = "ON_DEMAND"
  disk_size      = 20

  scaling_config {
    desired_size = 1
    min_size     = 1
    max_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_readonly
  ]

  tags = {
    Name      = "togglemaster-fase4-ng"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}
