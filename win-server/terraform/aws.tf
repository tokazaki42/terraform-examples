provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key

  region = var.region
}

provider http {
  version = "~> 1.1"
}
