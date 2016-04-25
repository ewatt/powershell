# RestartRemoteSystems.psm1
# by
# 2015-

<#
Using a script, from your workstation, automatically restart all of your 
remote systems (except your workstation), starting with your AD server. 
Do not hard-code the server names (get them from AD), (remember to 
exclude your workstation). Wait for the AD server to restart then 
restart the next system, confirming that each one has started before 
restarting the next one. Confirm that each system is running by 
displaying the IP address and startup time. Your script should be able 
to work with one system or 1000’s of systems.
#>
Function RestartRemoteSystems {
    Clear-Host
    Write-Host "[!] RestartRemoteSystems"
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *