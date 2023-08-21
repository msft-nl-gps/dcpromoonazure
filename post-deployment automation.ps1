$root_domain = "tst.loc"
$netbios_name = "tst"
$root_dc_admin_username = "tdadmin"
$root_dc_admin_password = "P@ssw0rd1234!"
 
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


##################################
#after reboot
$site_name = "ts1"
Import-Module ActiveDirectory
New-ADReplicationSite -Name $site_name
Set-ADReplicationSiteLink -Identity "DEFAULTIPSITELINK" -SitesIncluded @{Add="$site_name"}
New-ADUser -Name "tdadmin2" -SamAccountName "tdadmin2" -UserPrincipalName "tdadmin2@tst.loc" -Enabled $true -AccountPassword (ConvertTo-SecureString "P@ssw0rd1234!" -AsPlainText -Force)
Add-ADGroupMember -Identity "Enterprise Admins" -Members "tdadmin2"

#################################

# can ping tst.loc at this point
 
$root_domain = "tst.loc"
$site_name = "ts1"
$root_dc_admin_username = "tdadmin2"
$root_dc_admin_password = "P@ssw0rd1234!"
 
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

#############
