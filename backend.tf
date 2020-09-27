terraform {
  backend "consul" {
    scheme = "http"
    path   = "terraform/wireguard-us-east.tfstate"
  }
}