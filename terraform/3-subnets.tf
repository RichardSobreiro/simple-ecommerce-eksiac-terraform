resource "aws_subnet" "subnet-private-us-east-1a-simpleecommerce" {
  vpc_id            = aws_vpc.vpc-simpleecommerce.id
  cidr_block        = "10.0.0.0/19"
  availability_zone = "us-east-1a"

  tags = {
    "Name"                            = "subnet-private-us-east-1a-simpleecommerce"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/iamrole-eks-simpleecommerce"      = "owned"
  }
}

resource "aws_subnet" "subnet-private-us-east-1b-simpleecommerce" {
  vpc_id            = aws_vpc.vpc-simpleecommerce.id
  cidr_block        = "10.0.32.0/19"
  availability_zone = "us-east-1b"

  tags = {
    "Name"                            = "subnet-private-us-east-1b-simpleecommerce"
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/iamrole-eks-simpleecommerce"      = "owned"
  }
}

resource "aws_subnet" "subnet-public-us-east-1a-simpleecommerce" {
  vpc_id                  = aws_vpc.vpc-simpleecommerce.id
  cidr_block              = "10.0.64.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "subnet-public-us-east-1a-simpleecommerce"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/iamrole-eks-simpleecommerce" = "owned"
  }
}

resource "aws_subnet" "subnet-public-us-east-1b-simpleecommerce" {
  vpc_id                  = aws_vpc.vpc-simpleecommerce.id
  cidr_block              = "10.0.96.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                       = "subnet-public-us-east-1b-simpleecommerce"
    "kubernetes.io/role/elb"     = "1"
    "kubernetes.io/cluster/iamrole-eks-simpleecommerce" = "owned"
  }
}