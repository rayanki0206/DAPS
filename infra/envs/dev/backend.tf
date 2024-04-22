terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "elanco_animal_health"
    workspaces {
      name = "dat-dapp-dev"
    }
  }
}
