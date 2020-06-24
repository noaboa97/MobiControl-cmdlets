# MobiControl-cmdlets
PowerShell Cmdlets for MobiControl API

Use Get-Help [functionname or scriptname] -full to checkout parameters and how to use.

Save the .psm in one of the module paths. Check the paths with the variable $env:PSModulePath

# Examples

## Unsecure WebConsole
If your Server doesn't have a certificate you need to run ```Set-TrustAllCertsPolicy``` first.

## Get-MCToken
```
#Lokaler User im MobiControl
$MCUsername = "Username"
$MCPassword = "Password"

#MobiControl Server
$MCFQDN = "Server"

#Client
$ClientID = "ClientID"
$Clientsecret = "Secret"

$token = Get-MCToken -MCUsername $MCUsername -MCPassword $MCPassword -MCFQDN $MCFQDN -ClientID $ClientID -ClientSecret $Clientsecret
```
## Get-MCDeviceGroup
```
Get-MCDeviceGroup -Token $toke -Path "\\Root\subgroup"#<---------- without backslash at the end of the path or it will throw an error
```
## Get-MCDeviceGroups
```
Get-MCDeviceGroups -Token $token -parentPath "\\Root\subgroup"#<---------- without backslash at the end of the path or it will throw an error
```
## Add-MCDeviceGroup
```
Add-MCDeviceGroup -Token $token -Name "Groupname" -Icon None -Kind Regular -Path "\\Root\Subgroop\"#<---------- with backslash at the end or it will throw an error
```
## Remove-MCDeviceGroup
```
Remove-MCDeviceGroup -Toke $token -Name "Groupname" -Path "\\Root\"
```
## Get-MCProfiles
```
Get-MCProfiles -Token $Token -nameContains "Lockdown"
```
