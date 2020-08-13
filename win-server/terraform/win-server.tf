

data "template_file" "userdata_win" {
  template = <<EOF
<script>
echo "" > _INIT_STARTED_
net user ${var.INSTANCE_USERNAME} /add /y
net user ${var.INSTANCE_USERNAME} ${var.INSTANCE_PASSWORD}
net localgroup administrators ${var.INSTANCE_USERNAME} /add
echo "" > _INIT_COMPLETE_
</script>
<powershell>
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -name "ConsentPromptBehaviorAdmin"  -value "0"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -name "EnableLUA" -value "0"
Set-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -name "PromptOnSecureDesktop" -value "0"

# Display current User info
[System.Security.Principal.WindowsIdentity]::GetCurrent()

# Install the OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# get public key in the instance meta data and create the authorized keys file.
$administratorsKeyPath =  Join-Path $env:ProgramData 'ssh\administrators_authorized_keys'
Invoke-RestMethod -Uri http://169.254.169.254/latest/meta-data/public-keys/0/openssh-key/ |
    Out-File -FilePath $administratorsKeyPath -Encoding ascii

# Configure sshd service setting
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

## modify permission of the authorized key file
$administratorsKeyPath =  Join-Path $env:ProgramData 'ssh\administrators_authorized_keys'
$acl = Get-Acl $administratorsKeyPath
Get-Acl $administratorsKeyPath
$acl.SetAccessRuleProtection($true,$true)
$removeRule =  $acl.Access | Where-Object { $_.IdentityReference -eq 'NT AUTHORITY\Authenticated Users' }
$acl.RemoveAccessRule($removeRule)
$acl | Set-Acl -Path $administratorsKeyPath
Get-Acl $administratorsKeyPath

</powershell>
<persist>false</persist>
EOF
}

resource "aws_instance" "win-server" {
  ami                    = var.WIN_AMIS[var.region]
  instance_type          = "t3.large"
#  key_name               = aws_key_pair.ssh-key.key_name
  user_data              = data.template_file.userdata_win.rendered
  vpc_security_group_ids = [ aws_security_group.allow-rdp.id] 
  subnet_id              = aws_subnet.public_a.id
  iam_instance_profile   = aws_iam_instance_profile.systems_manager.name
  tags = {
    Name = "Windows_Server"
  }

}

# ElasticIP
resource "aws_eip" "win-sever-ip" {
  instance = "${aws_instance.win-server.id}"
  vpc      = true
}

output "ip" {
  value = "${aws_instance.win-server.public_ip}"
}


