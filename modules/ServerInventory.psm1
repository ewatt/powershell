# ServerInventory.psm1
# by Ian Watt
# 2015-03-22

<#
.SYNOPSIS
a)
Get the names of all domain computers and store them in an array. Test 
to see if they are up and responding. Write to a text file, each system
name that did not response as being available. Save this file to C:\Temp
b)
Write a script that will get information about hard drives (total size 
in megabytes, free space in megabytes) and amount of RAM (in gigabytes) 
and operating system. Save this file to the c:\temp folder. This file 
will be used to gather information about each remote system. 
c)
For each system that responded as “on”, execute the script created in 
step “b”. Write the hard drive, RAM and operating system data to a web 
page that will display the system name(s) and the data found in part 
“b”. 
If the output deals with multiple OS’s, then make sure the output is 
sorted by OS. Make sure the output is displayed so that there are no 
significant gaps between the columns. The browser should open 
automatically to display this page. In addition, display the “computer 
names” only, for those systems that did not respond, at the bottom of 
the web page.
.DESCRIPTION

.PARAMETER 

.EXAMPLE

.LINK

.NOTES
NAME: 
AUTHOR: Ian Watt
LASTEDIT: 2015-03-18
#>
Function ServerInventory {

    Clear-Host

    $TempPath = "C:\Temp"
    $ComputersFile = "$TempPath\computers.txt"
    $ComputersResponsiveFile = "$TempPath\computers-responsive.txt"
    $ComputersNotResponsiveFile = "$TempPath\computers-nonresponsive.txt"
    $ComputersInfoHtmlFile = "$TempPath\computers-information.html"
    $ComputersInfoHtml = @()

    $HtmlStyleSheet = $PSScriptRoot + '\style.css'
    $HtmlReportTitle = '<h1>Active Directory Computer Information</h1>'
    
    # Get a list of computers from Active Directory.
    $Computers = Get-ADComputer -Filter 'ObjectClass -eq "Computer"' `
        | Select -Expand Name

    # Create the paths and files neccessary.
    CreateFileIfNotExist -Path $TempPath -Type directory | Out-Null
    CreateFileIfNotExist -Path $ComputersFile -Type file | Out-Null
    CreateFileIfNotExist -Path $ComputersResponsiveFile -Type file | Out-Null
    CreateFileIfNotExist -Path $ComputersNotResponsiveFile -Type file | Out-Null

    # Clear each file.
    Clear-Content $ComputersFile
    Clear-Content $ComputersResponsiveFile
    Clear-Content $ComputersNotResponsiveFile

    # Write computer list to $ComputersFile
    Write-Output $Computers `
        | Out-File -FilePath $ComputersFile
    
    # Check if a computer is responsive.
    Foreach ($Computer in $Computers) {
        If (Test-Connection -ComputerName $Computer -TimeToLive 2 -Count 1 -Quiet) {
            # Write computer name to $ComputersResponsiveFile
            Write-Verbose "[+] $Computer is active."
            Write-Output $Computer `
                | Out-File -Append -FilePath $ComputersResponsiveFile
        }
        Else {
            # Write computer name to $ComputersNotResponsive
            Write-Verbose "[-] $Computer is not responsive!"
            Write-Output $Computer `
                | Out-File -Append -FilePath $ComputersNotResponsiveFile
        }
    }

    # get the list of responsive and non-responsive computers into variables.
    $ComputersResponsive = Get-Content -Path $ComputersResponsiveFile
    $ComputersNotResponsive = Get-Content -Path $ComputersNotResponsiveFile

    $ComputersInfoHtml += "<ol>"

    # Gather info about each responsive computer.
    ForEach ($Computer in $ComputersResponsive) {
        
        # Prepend computer name heading to the html tables.
        $ComputersInfoHtml += "<li><h2>$Computer</h2></li>"

        # create a new cimsession for computer
        $objSession = New-CimSession -ComputerName $Computer
        
        # Get hard disk info and convert to html table.
        $ComputersInfoHtml += $objSession `
            | Get-CimInstance -Namespace root/CIMV2 -ClassName Win32_LogicalDisk -Filter "DriveType=3" `
            | Select DeviceID, FileSystem, FreeSpace, Size, VolumeSerialNumber `
            | ConvertTo-Html -As List -Fragment -PreContent "<ul><li><h3>Disk Info</h3></li></ul>" `
            | Out-String
        
        # Get memory info and convert to html table.
        $ComputersInfoHtml += $objSession `
            | Get-CimInstance -Namespace root/CIMV2 -ClassName Win32_PhysicalMemory `
            | Select Capacity, Speed `
            | ConvertTo-Html -As List -Fragment -PreContent "<ul><li><h3>Memory Info</h3></li></ul>" `
            | Out-String

        # Get Operating System info and convert to html table.
        $ComputersInfoHtml += $objSession `
            | Get-CimInstance -Namespace root/CIMV2 -ClassName Win32_OperatingSystem `
            | Select Caption, Version, OSArchitecture, OSLanguage, InstallDate, SerialNumber, Status `
            | ConvertTo-Html -As List -Fragment -PreContent "<ul><li><h3>Operating System Info</h3></li></ul>" `
            | Out-String
    }

    $ComputersInfoHtml += "</ol>"

    # append the non-responsive computers to the end of the html
    $ComputersInfoHtml += $ComputersNotResponsive `
        | ForEach-Object {
                # http://stackoverflow.com/questions/14392693/output-an-array-to-html-file
                Add-Member -InputObject $_ -Type NoteProperty -Name Value -Value $_; $_ } `
        | ConvertTo-Html -Property Value -Fragment `
            -PreContent "<h2>Non-Responsive Computers</h2><ul><li>" `
            -PostContent "</li></ul>" `
        | Out-String


    # combine all the html tables together
    ConvertTo-Html -CssUri $HtmlStyleSheet `
                   -Title "Active Directory Computer Information" `
                   -Body $HtmlReportTitle `
                   -PreContent $ComputersInfoHtml `
                   -PostContent "<br /><h5>Report Generated on $(Get-Date) $([System.TimeZoneInfo]::Local.DisplayName)." `
        | Out-File -FilePath $ComputersInfoHtmlFile

    # Open the html file in the associated web browser.
    Invoke-Expression $ComputersInfoHtmlFile
 
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *