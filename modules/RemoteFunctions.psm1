# RemoteFunctions.psm1
# by
# 2015-

<#
Create a function that will test to see if a particular user has an 
active account in Active Directory.  Also, check to see if the user 
has ever logged on
Ask the user to enter an account name and pass this value to the 
function
#>
Function RemoteFunctions {
    Clear-Host
    Write-Host "[!] RemoteFunctions"
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *