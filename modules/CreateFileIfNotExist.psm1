Function CreateFileIfNotExist {
<#
.SYNOPSIS
Creates a file or directory if it does not exist.
.DESCRIPTION
Checks for the existence of a file or directory and if it does not exist, it will be created.
.EXAMPLE
CreateFileIfNotExist -Path filename -Type file
.PARAMETER path
The path name of the file to check for and create.
.PARAMETER type
The type of file to create. Either `file` or `directory`. Defaults to `file`.
.NOTES
NAME: CreateFileIfNotExist
AUTHOR: Ian Watt
LASTEDIT: 2015-03-22
#>
    Param (
        [Parameter(
            Mandatory=$True,
            ValueFromPipeline=$True,
            ValueFromPipelineByPropertyName=$True,
            Position=1)]
            [Alias('path')]
            [String]$NewFile,
        [Parameter(
            Position=2)]
            [Alias('type')]
            [String]$FileType="file"
    )
    $Return = $False

    # Check if the file exists.
    If (Test-Path -Path $NewFile) {
        Write-Verbose "[!] File $NewFile already exists!"
        $Return = $True
    }
    Else {
        # Attempt file creation.
        Write-Verbose "[!] Creating file $NewFile..."
        If (New-Item -ItemType file -Path $NewFile) {
            Write-Verbose "[+] File $NewFile created successfully!"
            $Return = $True
        }
        Else {
            Write-Verbose "[-] Error creating $NewFile!"
        }
    }
    # Return code to calling function.
    # if the file exists or was created successfully, return true.
    # if the file does not exist and was not created, return false.
    Write-Output $Return
}

Export-ModuleMember -Function *
