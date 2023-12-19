resource "aws_iam_role" "iamrole-eks-simpleecommerce" {
  name = "iamrole-eks-simpleecommerce"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "iamrole-eks-simpleecommerce-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.iamrole-eks-simpleecommerce.name
}

resource "aws_eks_cluster" "ekscluster-simpleecommerce" {
  name     = var.cluster_name
  role_arn = aws_iam_role.iamrole-eks-simpleecommerce.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.subnet-private-us-east-1a-simpleecommerce.id,
      aws_subnet.subnet-private-us-east-1b-simpleecommerce.id,
      aws_subnet.subnet-public-us-east-1a-simpleecommerce.id,
      aws_subnet.subnet-public-us-east-1b-simpleecommerce.id
    ]
  }

  depends_on = [aws_iam_role_policy_attachment.iamrole-eks-simpleecommerce-AmazonEKSClusterPolicy]
}