variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "WIN_AMIS" {
  type = map
  default = {
    ap-northeast-1 = "ami-0f1b16857e17905cb"
  }
}


variable "instance_ami" {
  type    = string
  default = "ami-0cfa3caed4b487e77"
}

# variable "PATH_TO_PRIVATE_KEY" { default = "mykey" }
variable "INSTANCE_USERNAME" {}
variable "INSTANCE_PASSWORD" {}
variable "ADDC_PASSWORD" {}
variable "AD_DOMAIN_NAME" {}


variable "pubkey_file_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}
