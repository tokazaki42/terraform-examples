variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable  "gp2_volume_size" {
  type = number
  default = 20
}

variable "pubkey_file_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "instance_ami" {
  type    = string
  default = "ami-0cfa3caed4b487e77"
}

variable "certificate_arn" {}

variable "alb_certificate_arn" {
  type = string
  default = ""
}