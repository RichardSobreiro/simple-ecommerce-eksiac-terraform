resource "aws_iam_role" "nodes" {
  name = "iamrole-eksclusternodes-simpleecommerce"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "tls_private_key" "eks_nodes_ssh_private_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "eks_nodes_ssh_key_pair" {
    key_name = var.eks_nodes_keypair
    public_key = tls_private_key.eks_nodes_ssh_private_key.public_key_openssh
}

# resource "local_file" "eks_nodes_private_key_local_file" {
#     content  = tls_private_key.eks_nodes_ssh_private_key.private_key_pem
#     filename = "${var.eks_nodes_keypair}.pem"
# }

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.ekscluster-simpleecommerce.name
  node_group_name = "private-nodes"
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    aws_subnet.subnet-private-us-east-1a-simpleecommerce.id,
    aws_subnet.subnet-private-us-east-1b-simpleecommerce.id
  ]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t3.small"]

  remote_access {
    ec2_ssh_key = var.eks_nodes_keypair
    source_security_group_ids = [module.bastion_instance_sg.security_group_id]
  }

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 0
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  # taint {
  #   key    = "team"
  #   value  = "devops"
  #   effect = "NO_SCHEDULE"
  # }

  # launch_template {
  #   name    = aws_launch_template.eks-with-disks.name
  #   version = aws_launch_template.eks-with-disks.latest_version
  # }

  depends_on = [
    aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
    aws_key_pair.eks_nodes_ssh_key_pair,
    module.bastion_instance_sg
  ]
}

# resource "aws_launch_template" "eks-with-disks" {
#   name = "eks-with-disks"

#   key_name = "local-provisioner"

#   block_device_mappings {
#     device_name = "/dev/xvdb"

#     ebs {
#       volume_size = 50
#       volume_type = "gp2"
#     }
#   }
# }