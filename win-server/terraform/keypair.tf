resource "aws_key_pair" "ssh-key" {
  key_name   = "example-operation-pubkey"
  public_key = file(var.pubkey_file_path)
}
