terraform {
  backend "s3" {
    bucket       = "togglemaster-fase4-terraform-186107385777"
    key          = "terraform/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}
