$site_name = "ts1"
$site_subnet = "10.221.0.0/16"

Import-Module ActiveDirectory
New-ADReplicationSite -Name $site_name
New-ADReplicationSubnet -Name $site_subnet -Site $site_name
Set-ADReplicationSiteLink -Identity "DEFAULTIPSITELINK" -SitesIncluded @{Add="$site_name"}

