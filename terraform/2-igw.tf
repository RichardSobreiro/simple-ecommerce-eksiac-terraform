resource "aws_internet_gateway" "igw-simpleecommerce" {
  vpc_id = aws_vpc.vpc-simpleecommerce.id

  tags = {
    Name = "igw-simpleecommerce"
  }
}