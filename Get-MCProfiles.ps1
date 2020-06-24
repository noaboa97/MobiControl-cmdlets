function Get-MCProfiles {

    <#

    .SYNOPSIS
    Gets a list of profiles

    .DESCRIPTION
    Gets a list of profiles

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server.  Leave it blank and the function will be called to enter the details.

    .PARAMETER nameContains
    Only return profiles whose name contains this value

    .PARAMETER withStatuses
    Only return profiles that have statuses that match one of the values in this list. Provided as a comma-separated list of ProfileVersionStatus values.

    .PARAMETER forFamilies
    Only return profiles that are targeting one of the families in this list. Provided as a comma-separated list of DeviceFamily values

    .PARAMETER hasDraft
    Only return profiles that have a current draft. When false, only return profiles that do not have a draft. If null, then do not take draft status into account

    .PARAMETER hasSchedule
    Only return profiles that currently have a schedule. When false, only return profiles that do not have a schedule. If null, then do not take schedule status into account

    .PARAMETER order
    Determines the order. Example: +property1,-property2

    .PARAMETER skip
    Determines how many entities to skip

    .PARAMETER take
    Determines how many entities to take

    .OUTPUTS
    list of profiles

    .NOTES
    Version:        1.0
    Author:         Noah Li Wan Po
    Creation Date:  24.06.2020
    Purpose/Change: Initial function development
  
    .EXAMPLE
    .\Get-MCProfiles.ps1

    .EXAMPLE
    Get-MCProfiles 

    .EXAMPLE
    Get-MCProfiles 

    #>

    Param (
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter Authentication Token", Position = 0)]
        [string]$Token,
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter a string which the name should contain", Position = 1)]
        [string]$nameContains,
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter the status of the profiles to be shown", Position = 2)]
        [ValidateSet("Disabled", "Assigned", "Draft")]
        [string]$withStatuses,
        [ValidateSet("AndroidWork", "AndroidPlus")]
        [parameter(valuefrompipeline = $true, HelpMessage = "Enter the family of the profiles to be shown", Position = 3)]
        [string]$forFamilies,
        [parameter(valuefrompipeline = $true, HelpMessage = "Show only profiles with a draft", Position = 4)]
        [string]$hasDraft,
        [parameter(valuefrompipeline = $true, HelpMessage = "Show only profiles with a shedule", Position = 5)]
        [string]$hasSchedule,
        [parameter(valuefrompipeline = $true, HelpMessage = "Show only profiles with a autoinstall", Position = 6)]
        [string]$autoInstallOnly,
        [parameter(valuefrompipeline = $true, HelpMessage = "Determines the order. Example: +property1,-property2", Position = 7)]
        [string]$order,
        [parameter(valuefrompipeline = $true, HelpMessage = "Determines how many entities to skip", Position = 8)]
        [string]$skip,
        [parameter(valuefrompipeline = $true, HelpMessage = "Determines how many entities to take", Position = 9)]
        [string]$take
    )

    if($Token -eq ""){
    
        $Token = Get-MCToken
    
    }

    $Header = @{}
    $Header["Authorization"] = "Bearer " + $Token

    #hashtable of all variables
    $hash = @{}
    $hash["nameContains"]=$nameContains
    $hash["withStatuses"]=$withStatuses
    $hash["forFamilies"]=$forFamilies
    $hash["hasDraft"]=$hasDraft
    $hash["hasSchedule"]=$hasSchedule
    $hash["autoInstallOnly"]=$autoInstallOnly
    $hash["order"]=$order
    $hash["skip"]=$skip
    $hash["take"]=$take

    #hashtable for the API request
    $body = @{}

    #gets rid of emtpy values 
    foreach($line in $hash.GetEnumerator()){

        if($line.Value -ne ""){
    
            $body["$($line.name)"]=$line.value

        }
    
    }

    #API Request
    if($body.count -eq 0){
        
        $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/profiles -ContentType "application/json" -Method GET -Headers $Header 

    }
    else{
        
        $response = Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/profiles -ContentType "application/json" -Method GET -Headers $Header -Body $Body

    }

    return $response

 }

Get-MCProfiles $Token -take 1 -verbose
