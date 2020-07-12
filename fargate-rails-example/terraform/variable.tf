variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable  "gp2_volume_size" {
  type = number
  default = 10
}

variable "alb_certificate_arn" {
  type = string
  default = ""

}