# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "mikesupertrampster-corp"

    workspaces {
      name = "terraform-jaeger-dev"
    }
  }
}
