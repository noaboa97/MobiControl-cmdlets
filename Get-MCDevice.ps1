function Get-MCDevice {

    <#

    .SYNOPSIS
    Retrieves a single MobiControl device  

    .DESCRIPTION
    Retrieves a single MobiControl device   

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server

    .PARAMETER DeviceId
    Specify the device ID of the device

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  08.06.2021
    Purpose/Change: Initial function development
  
    .EXAMPLE
    .\Get-MCDevice.ps1 Token DeviceId

    .EXAMPLE
    Get-MCDevice  Token DeviceId

    .EXAMPLE
    Get-MCDeviceGroup -Token "jdfdönbvlkö34nlk" -DeviceId "0E11AA010B4AC7B12800-0050BF7A60E2" 

    #>

    Param (
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter Authentication Token", Position = 0)]
        [string]$Token,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter device ID", Position = 1)]
        [string]$DeviceId
    )

    if($Token -eq ""){
    
        $Token = Get-MCToken
    
    }

    #Header with Token Authorization
    $Header = @{}
    $Header["Authorization"] = "Bearer " + $Token

    #API Request
    $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devices/$DeviceId -Method GET -Headers $Header

    return $response
}

