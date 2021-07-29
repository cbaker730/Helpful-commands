Function Get-AccountInfo($Username)
{
    # Get account information by checking two domains
    # Requires: RSAT https://docs.microsoft.com/en-us/windows-server/remote/remote-server-administration-tools
    # Usage: . .\Get-AccountInfo.ps1; Get-AccountInfo cbaker730_da

    try {
        Get-ADUser -Identity $Username
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
        try {
            $dc = (Get-ADDomainController -Discover -Domain "other_domain" | Select-Object -ExpandProperty IPv4Address)
            Get-ADUser $Username -Server $dc
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
            "User does not exist."
        }
    }

}


Function Get-GroupInfo($Groupname)
{
    # Get AD group information (metadata and membership) by checking two domains
    # Requires: RSAT https://docs.microsoft.com/en-us/windows-server/remote/remote-server-administration-tools
    # Usage: . .\Get-AccountInfo.ps1; Get-GroupInfo "Domain Admins"

    try {
        Get-ADGroup -Identity $Groupname
        Get-ADGroupMember $Groupname | %{$_.name}
    }
    catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
        try {
            $dc = (Get-ADDomainController -Discover -Domain "other_domain" | Select-Object -ExpandProperty IPv4Address)
            Get-ADGroup $Groupname -Server $dc
            Get-ADGroupMember $Groupname -Server $dc | %{$_.name}
        }
        catch [Microsoft.ActiveDirectory.Management.ADIdentityResolutionException] {
            "Group does not exist."
        }
    }
}
