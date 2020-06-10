function Get-MCDeviceGroups {

    <#

    .SYNOPSIS
    Gets MobiControl device groups 

    .DESCRIPTION
    Gets all MobiControl the device groups if no path is specified

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server

    .PARAMETER parentPath
    Specify the parent group to show the subgroups
    If not specified all device groups will be listed recursively

    .OUTPUTS
    Device group or groups

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  10.06.2020
    Purpose/Change: Initial function development
  
    .EXAMPLE
    .\Get-MCDeviceGroups.ps1 Token Path

    .EXAMPLE
    Get-MCDeviceGroups Token Path

    .EXAMPLE
    Get-MCToken -Token jdfdönbvlkö34nlk -Path \\root\subgroup

    #>

    Param (
        [parameter(valuefrompipeline = $true,  mandatory = $true, HelpMessage = "Enter Authentication Token", Position = 0)]
        [string]$Token,
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter parentPath", Position = 1)]
        [string]$parentPath
    )


    $Header = @{}
    $Header["Authorization"] = "Bearer " + $Token

    if($parentPath -ne $null){
       $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devicegroups?parentPath=$parentpath -ContentType "application/json" -Method GET -Headers $Header # -Body $Body
    }
    else{
       $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devicegroups -ContentType "application/json" -Method GET -Headers $Header 
    }

    return $response

}