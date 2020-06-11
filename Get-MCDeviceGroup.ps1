function Get-MCDeviceGroup {

    <#

    .SYNOPSIS
    Gets a single MobiControl device group 

    .DESCRIPTION
    Gets a single MobiControl the device group 

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server. Leave it blank and the function will be called to enter the details.

    .PARAMETER Path
    Specify the group 
    Without a backslash on the end

    .OUTPUTS
    Specified device group details

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  11.06.2020
    Purpose/Change: Initial function development
  
    .EXAMPLE
    .\Get-MCDeviceGroup.ps1 Token Path

    .EXAMPLE
    Get-MCDeviceGroup Token Path

    .EXAMPLE
    Get-MCDeviceGroup -Token jdfdönbvlkö34nlk -Path \\root\subgroup

    #>

    Param (
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter Authentication Token", Position = 0)]
        [string]$Token,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter parentPath", Position = 1)]
        [string]$Path
    )

    if($Token -eq ""){
    
    $Token = Get-MCToken
    
    }

    $Header = @{}
    $Header["Authorization"] = "Bearer " + $Token

    #Double Encodes the Path
    $EncodedPath = [System.Web.HttpUtility]::UrlEncode($Path)
    $doubleEncodedPath = [System.Web.HttpUtility]::UrlEncode($EncodedPath)
   
    $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devicegroups/$doubleEncodedPath -ContentType "application/json" -Method GET -Headers $Header
  
    return $response

}