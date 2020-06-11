﻿function Set-TrustAllCertsPolicy {
    if (([System.Net.ServicePointManager]::CertificatePolicy).ToString() -eq "System.Net.DefaultCertPolicy"){
    add-type @"
    using System.Net;
    using System.Security.Cryptography.X509Certificates;
    public class TrustAllCertsPolicy : ICertificatePolicy {
       public bool CheckValidationResult(
            ServicePoint srvPoint, X509Certificate certificate,
           WebRequest request, int certificateProblem) {
               return true;
           }
    }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy
    }
}


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

function Remove-MCDeviceGroup {

    <#

    .SYNOPSIS
    Removes a MobiControl device group 

    .DESCRIPTION
    Removes a MobiControl device group 

    .PARAMETER Token
    Create the token with the script or function Get-MCToken and pass it to this function to authenticate with the MobiControl server

    .PARAMETER Name
    Specify the name of the group that should be deleted

    .PARAMETER Path
    Specify the path of the parent group

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
         [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter Authentication Token", Position = 0)]
         [string]$Token,
         [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter group name", Position = 1)]
         [string]$Name,
         [parameter(valuefrompipeline = $true, mandatory = $true, HelpMessage = "Enter Path", Position = 2)]
         [string]$Path
         )

    if($Token -eq ""){
    
        $Token = Get-MCToken
    
    }

    #Header with Token Authorization
    $Header = @{}
    $Header["Authorization"] = "Bearer " + $Token


    #Concactinates the Path and Name
    $Path=$Path+$Name

    #Double Encodes the Path
    $EncodedPath = [System.Web.HttpUtility]::UrlEncode($Path)
    $doubleEncodedPath = [System.Web.HttpUtility]::UrlEncode($EncodedPath)

    #API Request
    Invoke-restmethod -Uri https://$MCFQDN/mobicontrol/api/devicegroups/$doubleEncodedPath -ContentType "application/json" -Method DELETE -Headers $Header 

    return $response
}

