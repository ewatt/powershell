# FirewallStatus.psm1
# by
# 2015-

<#
- Using Active Directory your script will get all of the computer names 
in the domain. You will then save these names to a text file called 
mysystems.txt (saved to a folder of your choice). 
- Using the text file from “part (i)” you will read each computer name 
and determine whether the firewall on that system is turned on or off. 
If the firewall is “off”, then turn it on. Make sure you have actually 
turned it on by testing it a second time. If the firewall will not turn 
on, output the name of the computer and the firewall status.
- As you test each computer, get the names of the software that has 
been authorized to pass through the firewall. Produce output that will 
list these names for each computers in the text file.
#>
Function FirewallStatus {
    Clear-Host

    $TempPath = "C:\Temp"
    $ComputersFile = "$TempPath\computers.txt"

    $FirewallRegistryKeyPath = "HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\"

    # Get a list of computers from Active Directory.
    $Computers = Get-ADComputer -Filter 'ObjectClass -eq "Computer"' `
        | Select -Expand Name

    # Create the paths and files neccessary.
    CreateFileIfNotExist -Path $TempPath -Type directory | Out-Null
    CreateFileIfNotExist -Path $ComputersFile -Type file | Out-Null

    # Clear contents of $ComputersFile
    Clear-Content $ComputersFile

    # Write computer list to $ComputersFile
    Write-Output $Computers `
        | Out-File -FilePath $ComputersFile

    ForEach ($Computer in $Computers) {
        # Check if the system is connected before attempting to check it's firewall settings.
        If (Test-Connection -ComputerName $Computer -TimeToLive 2 -Count 1 -Quiet) {
            Write-Host "[+] Connection to $Computer is up."
            $ConnectionEnabled = $True

            # Create a new CIM session to query settings from the remote system.
            $Session = New-CimSession -ComputerName $Computer

            # We need to check to OS version because the windows firewall cmdlets only work 
            # with windows 8 and windows server 2012.
            # To check for older windows versions we need to check the registry at 
            # HKLM:\SYSTEM\CurrentControlSet\services\SharedAccess\Parameters\FirewallPolicy\
            # for each of the three firewall profiles and then enable the firewall using netsh.
            $Version = (Get-CimInstance -CimSession $Session -ClassName Win32_OperatingSystem).Version

            # We're only going to be using win7, win2008, win8, and win2012 systems.
            Switch -Wildcard ($Version) {
                "5.0.*" { Write-Host "[!] $Computer is win2000, $Version is not supported." }
                "5.1.*" { Write-Host "[!] $Computer is XP, $Version is not supported." }
                "6.0.*" { Write-Host "[!] $Computer is vista, $Version is not supported." }
                
                # Windows 7 or Windows Server 2008
                "6.1.*" { 
                    Write-Host "[!] $Computer is win7 or win2008, $Version" 
                    
                    # Check if each firewall profile is enabled.
                    Foreach ($FirewallProfile in @('Public','Standard','Domain')) {
                        
                        # Build the registry path for the current profile.
                        $FirewallRegistryKey = "${FirewallRegistryKeyPath}${FirewallProfile}Profile"

                        # check the registry key on the remote computer, 
                        # if the firewall is disabled we run netsh to enable it
                        # then the while loop will check again if the firewall is enabled.
                        # TODO:This will make an infinite loop if the firewall cannot be enabled.
                        While (Invoke-Command -ComputerName $Computer -ScriptBlock `
                                { 
                                    (((Get-ItemProperty -Path "${Using:FirewallRegistryKey}" `
                                                       -Name EnableFirewall).EnableFirewall) -eq 0) 
                                })
                        {
                            Write-Host "[-] Firewall is disabled on $computer for profile $FirewallProfile."
                            
                            # We need to copy the current profile to a new variable because the firewall
                            # stores the 'Private' profile in the 'StandardProfile' registry key.
                            # but we still need to check the 'StandardProfile' key after enabling the firewall.
                            # Why don't they have the same names like the other profiles?
                            $CurrentFirewallProfile = $FirewallProfile
                            If ($CurrentFirewallProfile -eq 'Standard') { $CurrentFirewallProfile = 'Private' }
                            
                            # Run netsh to enable the firewall.
                            # If we just changed the registry key the firewall won't start until the next reboot.
                            Invoke-Command -Computer $Computer -ScriptBlock `
                                { netsh advfirewall set ${Using:CurrentFirewallProfile}Profile state on }
                        }
                        Write-Host "[+] Firewall is enabled on $Computer for profile $FirewallProfile."
                    
                    }
                        
                }
                
                # Windows 8 or Windows Server 2012
                "6.2.*" { 
                    
                    Write-Host "[!] $Computer is win8 or win2012, $Version" 
                    
                    # Check if each firewall profile is enabled.
                    Foreach ($FirewallProfile in @('Public','Private','Domain')) {
                    
                        # Check if the firewall profile is disabled, attempt to enable the firewall profile,
                        # then the while loop will check again if the firewall is enabled.
                        # TODO:This will make an infinite loop if the firewall cannot be enabled.
                        While ((Get-NetFirewallProfile -CimSession $Session -Name $FirewallProfile).Enabled -eq 'False') {
                            Write-Host "[-] Firewall is disabled on $computer for profile $FirewallProfile."
                            Set-NetFirewallProfile -CimSession $Session -Name $FirewallProfile -Enabled 'True'
                        }
                        Write-Host "[+] Firewall is enabled on $Computer for profile $FirewallProfile."
                    
                    }

                }
                # Windows 8.1 is an oddball.
                "6.3.*" { Write-Host "[!] $Computer is win8.1, $Version is not supported." }
                "6.4.*" { Write-Host "[!] $Computer is Windows 10 Technical Preview, $Version is not supported." }
                "10.0.*" {Write-Host "[!] $Computer is Windows 10, $Version is not currently supported." }
                # if any other version is returned.
                "default" { Write-Host "[-] $Computer version is unknown or not supported, $Version" }
            }

            

        }
        Else {
            Write-Host "[-] Connection to $Computer is down."
            $ConnectionEnabled = $False
        }
    }


    PressAnyKeyToContinue
}

Export-ModuleMember -Function *