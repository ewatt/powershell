# Sessions.psm1
# by
# 2015-

<#
Create a session asking the user for a session name and a computer to 
connect to. Automatically list all sessions after a new one is created. 
Exit from the menu.
Enter the session and use some basic commands
Disconnect from the session and enter the session from another system. 
Disconnect when done.
Go back to the original system and kill the session.
Re-enter the menu.
#>
Function Sessions {
    Clear-Host
    Write-Host "[!] Sessions"
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *