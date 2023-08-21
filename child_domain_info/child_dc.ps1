# can ping tst.loc at this point

$root_domain = "tst.loc"
$site_name = "ts1"
$root_dc_admin_username = "janhein"
$root_dc_admin_password = "p@ssw0rd!"

Install-WindowsFeature -name AD-Domain-Services, DNS -IncludeManagementTools
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

$password = ConvertTo-SecureString $root_dc_admin_password -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ("$root_dc_admin_username@$root_domain", $password)
$dnscredential = New-Object System.Management.Automation.PSCredential ($root_dc_admin_username, $password)

Import-Module ADDSDeployment
Install-ADDSDomain `
-SafeModeAdministratorPassword $password `
-Credential $credential `
-DomainMode "Default" `
-DomainType "ChildDomain" `
-SiteName "$site_name" `
-NewDomainName "$site_name" `
-NewDomainNetbiosName "$site_name" `
-ParentDomainName "$root_domain" `
-DatabasePath "C:\Windows\NTDS"  `
-SysvolPath "C:\Windows\SYSVOL" `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$true `
-CreateDnsDelegation:$true `
-DnsDelegationCredential $dnscredential `
-NoGlobalCatalog:$false `
-InstallDns:$true `
-Confirm:$false `
-Force:$true `
-ErrorAction Stop
