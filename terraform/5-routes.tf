resource "aws_route_table" "routetable-private-simpleecommerce" {
  vpc_id = aws_vpc.vpc-simpleecommerce.id

  route {
    cidr_block                 = "0.0.0.0/0"
    nat_gateway_id             = aws_nat_gateway.nat-simpleecommerce.id
  }

  tags = {
    Name = "routetable-private-simpleecommerce"
  }
}

resource "aws_route_table" "routetable-public-simpleecommerce" {
  vpc_id = aws_vpc.vpc-simpleecommerce.id

  route {
    cidr_block                 = "0.0.0.0/0"
    gateway_id                 = aws_internet_gateway.igw-simpleecommerce.id
  }

  tags = {
    Name = "routetable-public-simpleecommerce"
  }
}

resource "aws_route_table_association" "subnet-private-us-east-1a-simpleecommerce" {
  subnet_id      = aws_subnet.subnet-private-us-east-1a-simpleecommerce.id
  route_table_id = aws_route_table.routetable-private-simpleecommerce.id
}

resource "aws_route_table_association" "subnet-private-us-east-1b-simpleecommerce" {
  subnet_id      = aws_subnet.subnet-private-us-east-1b-simpleecommerce.id
  route_table_id = aws_route_table.routetable-private-simpleecommerce.id
}

resource "aws_route_table_association" "subnet-public-us-east-1a-simpleecommerce" {
  subnet_id      = aws_subnet.subnet-public-us-east-1a-simpleecommerce.id
  route_table_id = aws_route_table.routetable-public-simpleecommerce.id
}

resource "aws_route_table_association" "subnet-public-us-east-1b-simpleecommerce" {
  subnet_id      = aws_subnet.subnet-public-us-east-1b-simpleecommerce.id
  route_table_id = aws_route_table.routetable-public-simpleecommerce.id
}