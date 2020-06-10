function Get-MCToken {

    <#

    .SYNOPSIS
    Creates the access Token for the MobiControl API 

    .DESCRIPTION
    Creates the access Token for the MobiControl API. There must e a local user in MobiControl and the CLientID and ClientSecret must be created on the MobiControl server with MobiControl Administration Utility (MCAdmin)

    .PARAMETER MCUsername
    Username of the local MobiControl account with administrator rights

    .PARAMETER MCPassword
    Password of the local MobiControl account

    .PARAMETER MCFQDN
    Full Qualified Domain Name of the MobiControl Server

    .PARAMETER ClientID
    ClientID Generated on the MobiControl Server with MobiControl Administration Utility (MCAdmin)

    .PARAMETER ClientSecret
    ClientSecret Generated on the MobiControl Server with MobiControl Administration Utility (MCAdmin)

    .OUTPUTS
    Access Token

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  10.06.2020
    Purpose/Change: Initial function development
  
    .EXAMPLE
    .\Get-MCToken.ps1 User Password MCServer

    .EXAMPLE
    Get-MCToken User Password MCServer

    .EXAMPLE
    Get-MCToken -MCUsername PowerShell -MCPassword Password -MCFQDN Servername

    #>

    Param (
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter MobiControl Username", Position = 0)]
        [string]$MCUsername,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter MobiControl Password", Position = 1)]
        [string]$MCPassword,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter MobiControl FQDN", Position = 2)]
        [string]$MCFQDN,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter MobiControl FQDN", Position = 3)]
        [string]$ClientID,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter MobiControl FQDN", Position = 4)]
        [string]$ClientSecret
        )

    #Encoding of the client data
    $IDSecret = $ClientID + ":" + $ClientSecret 
    $EncodedIDSecret = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($IDSecret))

    #Body message 
    $Body = @{}
    $Body["grant_type"]="password"
    $Body["username"]=$MCUsername
    $Body["password"]=$MCPassword

    #Header message
    $Header = @{}
    $Header["Authorization"] = "Basic " + $EncodedIDSecret

    $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/token -Method POST -Headers $Header -Body $Body


    $Token = $response.access_token

    return $Token
}