# ConstrainedEndpoints.psm1
# by
# 2015-

<#
Create a Constrained Endpoint that will only allow the 4 cmdlets, 
created in Section 7, to be available. The endpoint will be located on 
your third virtual system. You should be able to access these cmdlets 
from your workstation. Note, this Endpoint can be loaded into the 
system prior to the demonstration, to save time. The endpoint will only 
be accessible by users in the group created in part 6 of this 
assignment.
#>
Function ConstrainedEndpoints {
    Clear-Host
    Write-Host "[!] ConstrainedEndpoints"
    PressAnyKeyToContinue
}

Export-ModuleMember -Function *