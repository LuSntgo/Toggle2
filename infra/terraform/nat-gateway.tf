resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name      = "togglemaster-fase4-nat-eip"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}

resource "aws_nat_gateway" "togglemaster" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_a.id

  tags = {
    Name      = "togglemaster-fase4-nat"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }

  depends_on = [aws_internet_gateway.togglemaster]
}
