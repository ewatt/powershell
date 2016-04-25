# Assignment.ps1
# by Ian Watt
# 2015-03-22
# Assignment for WIN500

# Import modules for basic system tasks.
Import-Module $PSScriptRoot\Modules\Show-Menu.psm1
Import-Module $PSScriptRoot\Modules\PressAnyKey.psm1
Import-Module $PSScriptRoot\Modules\CreateFileIfNotExist.psm1

# Import modules for each menu entry.
Import-Module $PSScriptRoot\Modules\ServerInventory.psm1         # ian     DONE
Import-Module $PSScriptRoot\Modules\RestartRemoteSystems.psm1    # calvin
Import-Module $PSScriptRoot\Modules\Sessions.psm1                # calvin
Import-Module $PSScriptRoot\Modules\RemoteFunctions.psm1         # calvin
Import-Module $PSScriptRoot\Modules\UserConfiguration.psm1       # calvin
Import-Module $PSScriptRoot\Modules\MyCmdlets.psm1               # ian
Import-Module $PSScriptRoot\Modules\ConstrainedEndpoints.psm1    # ian
Import-Module $PSScriptRoot\Modules\JpegSearch.psm1              # ian     DONE
Import-Module $PSScriptRoot\Modules\FirewallStatus.psm1          # ian     DONE

# Stop script execution on error
$ErrorActionPreference = "Stop"

# Make the console look like the '80s
#$Host.UI.RawUI.ForegroundColor = "Green"
#$Host.UI.RawUI.BackgroundColor = "Black"

# Initialize the current menu selection to zero.
$Selection = 0

# Clear the screen.
Clear-Host

<#
This infinite loop is used to display the menu and always return to the 
menu after each selection.  The loop will exit only when the user 
selects the exit option.
#>
While ($True) {

    # Create the menu title.
    $MenuTitle = "WIN500 Assignment #1"

    # Create the menu options array.
    $MenuItems = @("Server Inventory",
                   "Restart Remote Systems",
                   "Sessions",
                   "Remote Functions",
                   "User Configuration",
                   "mycmdlets",
                   "Constrained Endpoints",
                   "Jpeg Search",
                   "Firewall Status",
                   "Exit"
                   )

    # Display the menu and get the selected menu item.
    $Selection = Show-Menu $MenuItems $Selection $MenuTitle

    # Call a function depending on which selection was chosen.
    # or throw an error if something went wrong.
    Switch ($Selection) {
        0 { ServerInventory }
        1 { RestartRemoteSystems }
        2 { Sessions }
        3 { RemoteFunctions }
        4 { UserConfiguration }
        5 { MyCmdlets }
        6 { ConstrainedEndpoints }
        7 { JpegSearch }
        8 { FirewallStatus }
        9 { Clear-Host; Exit }
        * { Throw "This should never happen. Good luck fixing it!" }
    }
}

#EOF