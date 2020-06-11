function Get-MCDeviceGroups {

    <#

    .SYNOPSIS
    Gets all MobiControl device groups or selected subgroups from parent folder

    .DESCRIPTION
    Gets all MobiControl the device groups if no path is specified. If a path of a parent groups is specified it gets the child groups.

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server.  Leave it blank and the function will be called to enter the details.

    .PARAMETER parentPath
    Specify the parent group to show the subgroups
    If not specified all device groups will be listed recursively

    .OUTPUTS
    all Device group or sub groups of the specified parent

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
    Get-MCDeviceGroup -Token jdfdönbvlkö34nlk -Path \\root\subgroup

    #>

    Param (
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter Authentication Token", Position = 0)]
        [string]$Token,
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter parentPath", Position = 1)]
        [string]$parentPath
    )

    if($Token -eq ""){
    
    $Token = Get-MCToken
    
    }

    $Header = @{}
    $Header["Authorization"] = "Bearer " + $Token

    if($parentPath -ne $null){
       $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devicegroups?parentPath=$parentpath -ContentType "application/json" -Method GET -Headers $Header
    }
    else{
       $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devicegroups -ContentType "application/json" -Method GET -Headers $Header 
    }

    return $response

}
