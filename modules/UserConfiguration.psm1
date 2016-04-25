# UserConfiguration.psm1
# by
# 2015-

<#
Create/modify/delete users and computers from script. Create a script 
that will complete the following activities. 
Note, this script will only be used once. The group/users will be need 
to available for part 8 of this assignment.
Ask for a user name and create a new user in active directory.
Ask for a group name and create a new group. Add the user name 
(from “a”) to this group. Display the users within this group. 
Automatically add the Admin account to this group.
Limit the use of PowerShell to users in this group. No users outside 
of this group should be able to start PowerShell.
#>
Function UserConfiguration {
    Clear-Host
    Write-Host "[!] UserConfiguration"
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *