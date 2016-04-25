# PressAnyKeyToContinue.psm1
# by Ian Watt
# 2015-03-22

Function PressAnyKeyToContinue {
<#
.SYNOPSIS
Waits for the user to press any key before continuing a script.
.DESCRIPTION
Displays the string "Press Any Key to Continue..." and waits for 
the user to press any key before continuing a script.
.EXAMPLE
PS> PressAnyKeyToContinue
.LINK
about_functions
about_functions_advanced
about_functions_advanced_parameters
.NOTES
NAME: PressAnyKeyToContinue
AUTHOR: Ian Watt
LASTEDIT: 2015-03-22
#>
    Write-Host "Press Any Key to Continue..."
    $DummyVariable = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

Export-ModuleMember -Function *
