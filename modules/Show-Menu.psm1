# show-menu.psm1
# by Ian Watt
# 2015-03-22

Function Update-Menu {
<#
.SYNOPSIS
Draws a menu to the screen.
.DESCRIPTION
Draws a menu to the screen and updates the current selection by 
alternating the foreground and background colors.
.PARAMETER MenuItems
A string array containing the menu items.
.PARAMETER MenuPosition
The position of the currently selected menu item.
.PARAMETER MenuTitle
A string value containing the title of the menu.
.EXAMPLE
PS> Update-Menu @('item1', 'iteme2', 'item3'), 0, 'Sample Menu'
.LINK
about_functions
about_functions_advanced
about_functions_advanced_parameters
.NOTES
NAME: Update-Menu
AUTHOR: Ian Watt
LASTEDIT: 2015-03-22
#>
    Param (
        [array]$MenuItems=@(0..9), 
        [int]$MenuPosition=0, 
        [string]$MenuTitle='Default Title'
        )
    
    # Store the foreground and background colors
    $fColor = $Host.UI.RawUI.ForegroundColor
    $bColor = $Host.UI.RawUI.BackgroundColor

    # Get the length of the longest menu item string
    $Length = $MenuItems.Length + 1

    # Clear the console
    Clear-Host

    # Draw a box of asterixes and print the title of the menu
    $MenuWidth = $MenuTitle.Length + 4
    Write-Host ("*" * $MenuWidth) -ForegroundColor $fColor -BackgroundColor $bColor
    Write-Host "* $MenuTitle *" -ForegroundColor $fColor -BackgroundColor $bColor
    Write-Host ("*" * $MenuWidth) -ForegroundColor $fColor -BackgroundColor $bColor
    
    # Loop thru the $MenuItems array and write each item to the console
    # if the item is currently selected, then alternate the foreground
    # and background colors
    for ($i = 0; $i -le $Length; $i++) {
        if ($i -eq $MenuPosition) {
            Write-Host "$($MenuItems[$i])" -ForegroundColor $bColor -BackgroundColor $fColor
        } else {
            Write-Host "$($MenuItems[$i])" -ForegroundColor $fColor -BackgroundColor $bColor
        }
    }
}


Function Show-Menu {
<#
.SYNOPSIS
Displays a menu on the console and listens for keypress.
.DESCRIPTION
Displays a menu on the console and listens for keypress and updates the screen 
based on the users selection.  The function returns the index of the selected 
menu item when the user presses the enter key.
.PARAMETER MenuItems
A string array containing the menu items.
.PARAMETER MenuPosition
The position of the currently selected menu item.
.PARAMETER MenuTitle
A string value containing the title of the menu.
.EXAMPLE
PS> Show-Menu @('item1', 'iteme2', 'item3'), 0, 'Sample Menu'
.LINK
about_functions
about_functions_advanced
about_functions_advanced_parameters
.NOTES
NAME: Show-Menu
AUTHOR: Ian Watt
LASTEDIT: 2015-03-22
#>
    Param ([array]$MenuItems=@(0..9),
           [int]$Position=0,
           [string]$MenuTitle='Default Title'
           )

    # Initalize constant variables for keypress events
    Set-Variable KeyUp -Option Constant -Value 38
    Set-Variable KeyDown -Option Constant -Value 40
    Set-Variable KeyEnter -Option Constant -Value 13

    # Initialize the keypress to zero so things don't get weird.
    $KeyCode = 0
    
    # Call Update-Menu to draw the menu to the console.
    Update-Menu $MenuItems $Position $MenuTitle

    # Loop until the user presses the Enter key
    While ($KeyCode -ne $KeyEnter) {
        
        # Capture keypress on keydown with no output
        $Press = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
        
        # Get the numerical keycode
        $KeyCode = $Press.VirtualKeyCode

        # Move the selection up if the Up Arrow key is pressed
        If ($KeyCode -eq $KeyUp) 
            { $Position-- }

        # Move the selection down if the Down Arrow key is pressed
        If ($KeyCode -eq $KeyDown) 
            { $Position++ }

        # Don't go past the top of the menu
        If ($Position -lt 0) 
            { $Position = $MenuItems.Length - 1 }

        # Don't go past the bottom of the menu
        If ($Position -ge $MenuItems.Length) 
            { $Position = 0 }

        # Swap the codeblocks of the last two if statements to disable wrap-around

        # Call DrawMenu to redraw the menu with the updated selection
        Update-Menu $MenuItems $Position $MenuTitle
    }
    
    # Return the index of the selected menu item to the calling function
    Write-Output $($Position)
}

Export-ModuleMember -Function *