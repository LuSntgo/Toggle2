resource "aws_internet_gateway" "togglemaster" {
  vpc_id = aws_vpc.togglemaster.id

  tags = {
    Name      = "togglemaster-fase4-igw"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
  }
}
