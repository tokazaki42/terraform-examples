variable "access_key" {}
variable "secret_key" {}
variable "region" {}

variable "gp2_volume_size" {
  type    = number
  default = 20
}

variable "pubkey_file_path" {
  description = "Please create your SSH key in advance."
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "instance_type" {
  type    = string
  default = "t3.nano"
}

variable "instance_ami" {
  description = "Please see: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/finding-an-ami.html#finding-an-ami-console"
  type = string
  default     = "ami-0cfa3caed4b487e77"      ## Ubuntu18.04 ap-northeast-1: Tokyo Region
#  default = "ami-0a634ae95e11c6f91"         ## Ubuntu18.04 us-west-2: Oregon Region                      
}