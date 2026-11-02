resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.togglemaster.id
  cidr_block              = "172.20.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name      = "togglemaster-public-a"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
    Type      = "Public"
  }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.togglemaster.id
  cidr_block              = "172.20.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name      = "togglemaster-public-b"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
    Type      = "Public"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.togglemaster.id
  cidr_block        = "172.20.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name      = "togglemaster-private-a"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
    Type      = "Private"
  }
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.togglemaster.id
  cidr_block        = "172.20.11.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name      = "togglemaster-private-b"
    Project   = "ToggleMaster"
    Phase     = "4"
    ManagedBy = "Terraform"
    Type      = "Private"
  }
}
