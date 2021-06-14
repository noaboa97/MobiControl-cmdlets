function Remove-MCDevice {

    <#

    .SYNOPSIS
    Removes a single MobiControl device  

    .DESCRIPTION
    Removes a single MobiControl device   

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server

    .PARAMETER DeviceId
    Specify the device ID of the device

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  05.06.2021
    Purpose/Change: Initial function development
  
    .EXAMPLE
    .\Remove-MCDevice.ps1 Token DeviceId

    .EXAMPLE
    Remove-MCDevice  Token DeviceId

    .EXAMPLE
    Add-MCDeviceGroup -Token "jdfdönbvlkö34nlk" -DeviceId "0E11AA010B4AC7B12800-0050BF7A60E2" 

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
    $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devices/$DeviceId -Method DELETE -Headers $Header

    return $response
}

