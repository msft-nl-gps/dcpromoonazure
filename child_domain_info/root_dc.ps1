$root_domain = "tst.loc"
$netbios_name = "tst"
$root_dc_admin_username = "janhein"
$root_dc_admin_password = "p@ssw0rd!"

Install-WindowsFeature -name AD-Domain-Services, DNS -IncludeManagementTools
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

$password = ConvertTo-SecureString $root_dc_admin_password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($root_dc_admin_username, $password)

Import-Module ADDSDeployment
Install-ADDSForest `
-DomainName "$root_domain" `
-SafeModeAdministratorPassword $password `
-DnsDelegationCredential $credential `
-DatabasePath 'C:\Windows\NTDS' `
-DomainMode 'Default' `
-DomainNetbiosName "$netbios_name" `
-ForestMode 'Default' `
-InstallDns `
-LogPath 'C:\Windows\NTDS' `
-SysvolPath 'C:\Windows\SYSVOL' `
-Force `
-Confirm:$false `
-NoRebootOnCompletion:$false `
-ErrorAction Stop
