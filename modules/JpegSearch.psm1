# JpegSearch.psm1
# by
# 2015-

<#
Jpeg files are supposed to be stored in a single location on each of 
your systems. In order to find out if this happening you will search 
all of your domain systems for these files and copy any .jpg files to 
a “picture” folder on the C: drive of each remote system. Do not hard 
code the computer names (look in Active Directory). Your script will do 
the following:
- Check for the existence of a “Picture” folder in C:\temp, on each of 
your systems. If it does not exist automatically create it.
- Search each computer (all folders and sub folders, excluding the 
Picture folders for .jpg files. When found, copy the file to the 
Picture folder on the current remote computer. Do not erase the 
original file. If there is a file(s) in the Picture folder that already 
matches the name of the file to be copied, do nor overwrite the file. 
Move on to the next file. Display the name(s) of the copied file(s) 
along with the computer name for each system.
#>
Function JpegSearch {
    Clear-Host
    
    #$SearchPath = "C:\"
    $SearchPath = "C:\Users\Ian\Downloads\images"

    $TargetPath = "C:\Temp\Picture"

    # Check if the $TargetPath already exists.
    If (Test-Path -Path $TargetPath) {
        Write-Host "[!] Path $TargetPath already exists."
    }
    # otherwise create the folder $TargetPath.
    else {
        Write-Host "[-] Path $TargetPath does not exist."
        If (New-Item -ItemType directory -Path $TargetPath) {
            Write-Host "[+] Creation of $TargetPath folder successful."
        }
        Else {
            Write-Host "[-] Error creating folder $TargetPath!"
        }
    }
    
    # Create the list of jpg files found on the system.
    # exclude $TargetPath from the search and SilentlyContinue is in case of unaccessable folders.
    $List = Get-ChildItem -Filter *.jpg -Path $SearchPath -Exclude $TargetPath -Recurse -ErrorAction SilentlyContinue

    # Parse thru the list of jpgs.
    Foreach ($Item in $List) {

        # Create the $TargetFilePath string from the $TargetPath and the filename of $Item.
        $TargetFilePath = [String]::Join("\", $TargetPath, $Item.Name)

        # Check if the file already exists.
        If (Test-Path -LiteralPath $TargetFilePath) {
            Write-Host "[!] File $TargetFilePath already exists."
        }
        Else {
            # otherwise copy the file in $Item to the $TargetPath and indicate success.
            If (Copy-Item -LiteralPath $Item -Destination $TargetPath) {
                Write-Host "[+] $TargetFilePath was copied successfully."
            }
            Else {
                Write-Host "[!] Error copying $Item to $TargetFilePath!"
            }
        }
    }

    # Wait for the user to press a key so they can review the output.
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *