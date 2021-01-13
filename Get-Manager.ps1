Function Get-Manager($account)
{
    # Get the reporting-line hierarchy for an AD account
    # Change the CEO's name signifying the top of the tree (e.g. William Gates)
    # Usage: Get-Manager jsmith


    # Get account details such as the user's DisplayName and Manager
    $user = Get-ADUser -Identity $account -Properties Manager, DisplayName
    $manager = $user.Manager


    # Add the user to the hierarchy to be returned (\-delimited list)
    If ($hierarchy -ne "") { $hierarchy += "\" }
    $hierarchy += "{1} {0}" -f ($user.DisplayName -split ', ')


    if ($manager) {

        # If recursion has reached the top of the tree, write the hierarchy and exit
        if ($hierarchy -like "*\William Gates*") {
            Write-Host $hierarchy
            Return $hierarchy
            #Exit 0
        }

        # We haven't reached the top of the tree, so recurse on the manager
        $hierarchy += Get-Manager $manager

    }


}
