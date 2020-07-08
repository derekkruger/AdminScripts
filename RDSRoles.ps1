# WVD Setup from https://www.policypak.com/pp-blog/windows-virtual-desktop

Set-executionpolicy -executionpolicy unrestricted
Install-Module -Name Microsoft.RDInfra.RDPowerShell -Force
Import-Module -Name Microsoft.RDInfra.RDPowerShell
Install-Module -Name Az -AllowClobber -Force
Import-Module -Name Az -AllowClobber

Add-RdsAccount -DeploymentUrl "https://rdbroker.wvd.microsoft.com"

#add tenant
New-RdsTenant -Name DRGWVDTenant -AadTenantId f16a1a87-f783-411d-b4ed-e15b6c7510f8 -AzureSubscriptionId 2303e96f-ef2c-4f61-84d2-252a2e4445f1

#rds owner
New-RdsRoleAssignment -RoleDefinitionName "RDS Owner" -UserPrincipalName derek.kruger@drgtech.com -TenantGroupName "Default Tenant Group" -TenantName DRGWVDTenant