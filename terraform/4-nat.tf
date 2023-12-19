resource "aws_eip" "nat-simpleecommerce" {
  tags = {
    Name = "nat-simpleecommerce"
  }
}

resource "aws_nat_gateway" "nat-simpleecommerce" {
  allocation_id = aws_eip.nat-simpleecommerce.id
  subnet_id     = aws_subnet.subnet-public-us-east-1a-simpleecommerce.id

  tags = {
    Name = "nat-simpleecommerce"
  }

  depends_on = [aws_internet_gateway.igw-simpleecommerce]
}