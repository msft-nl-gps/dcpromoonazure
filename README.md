# How to

Connect-AzAccount -Tenant 0c7daa66-c883-4fd1-adcc-1b5095a26476 # Tenant ID

Select-AzSubscription  5821b1a9-b483-4a16-aaec-8f8309f6f8cf # Subscription ID

$rg = "my-rg-01"; 

New-AzResourceGroup $rg -Location "uksouth"; 

New-AzResourceGroupDeployment -ResourceGroupName $rg -TemplateFile "infrastructure arm template.json"
