function Add-MCDeviceGroup {

    <#

    .SYNOPSIS
    Adds a MobiControl device group 

    .DESCRIPTION
    Adds a MobiControl device group 

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server

    .PARAMETER Name
    Specify the name of the new group

    .PARAMETER Path
    Specify the path of the new group

    .PARAMETER Icon
    Specify what Icon the group should have in the web interface

    .PARAMETER Kind
    Specify the kind/type of the group

    .OUTPUTS
    Device group or groups

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  10.06.2020
    Purpose/Change: Initial function development
  
    .EXAMPLE
    .\Add-MCDeviceGroup.ps1 Token Name Path Icon Kind

    .EXAMPLE
    Add-MCDeviceGroup Token Name Path Icon Kind

    .EXAMPLE
    Add-MCDeviceGroup -Token jdfdönbvlkö34nlk -Name "Example1" -Path "\\root\subgroup\ -Icon None -Kind Regular

    #>

    Param (
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter Authentication Token", Position = 0)]
        [string]$Token,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter group name", Position = 1)]
        [string]$Name,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter Path", Position = 2)]
        [string]$Path,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Choose Icon", Position = 3)]
        [ValidateSet("None", "Yellow", "Red", "Green", "Blue", "Purple", "Cyan")]
        [string]$Icon,
        [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Choose groups kind/type", Position = 4)]
        [ValidateSet("Regular", "Virtual")]
        [string]$Kind
    )

    if($Token -eq ""){
    
        $Token = Get-MCToken
    
    }

    #Header with Token Authorization
    $Header = @{}
    $Header["Authorization"] = "Bearer " + $Token


    #JSON Request to the API
    $Body = @{}
    $Body["Name"]=$Name
    $Body["Path"]=$Path+$Name

        #Device Group Icon ['Yellow', 'Red', 'Green', 'Blue', 'Purple', 'Cyan', 'None']
    $Body["Icon"]=$Icon

        #Device group kind ['Regular', 'Virtual']
    $Body["Kind"]=$Kind

    #Convert hash table to JSON
    $Body = $Body | ConvertTo-Json

    #API Request
    $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devicegroups -ContentType "application/json" -Method POST -Headers $Header -Body $Body

    return $response
}