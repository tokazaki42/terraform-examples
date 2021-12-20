remote_state {
  backend = "gcs"
  config = {
    bucket  = "terraform-state"
    prefix   = "cloudrun_example/${path_relative_to_include()}/terraform.tfstate"
  }
}
