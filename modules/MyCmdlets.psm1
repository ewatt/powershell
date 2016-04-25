# MyCmdlets.psm1
# by
# 2015-

<#
Create 4 cmdlets that will be included in a module called mycmdlets. 
Each cmdlet will have a help section and aliases. The cmdlets will 
perform the following tasks (be prepared to demonstrate them).
- Get the computer name, OS and up time of any computer active computer 
in the domain.
- Add a new user by asking for first and last name, and the department 
they are assigned to. The department they are in will be written to 
their accounts.
- Get the name, date and time all users last logged into the network. 
This list will be placed into html format and automatically displayed 
by the browser.
- Set the hours that a specific user can login to the network. By 
default a user can login 24/7. Restrict login access to weekdays only. 
Ask for the user name, then change the access hours to between 9:00am 
and 6:00pm.
#>
Function MyCmdlets {
    Clear-Host
    Write-Host "[!] MyCmdlets"
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *