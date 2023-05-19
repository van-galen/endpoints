function disable-vintageworkstations {

    $oldies = Get-ADComputer -filter {
        Enabled -eq $true -and
        (OperatingSystem -notlike 'windows*server*' -and OperatingSystem -like '*Windows*') -and
        (OperatingSystem -like '*XP*' -or OperatingSystem -like '*7*' -or OperatingSystem -like '*8*')
    } -properties samaccountname | Select samaccountname

    if ($oldies -ne $null){
    foreach ($oldie in $oldies){
    Disable-ADAccount -identity $oldie.samaccountname
    get-adcomputer -Identity $oldie.samaccountname | Move-ADObject -TargetPath "OU=DisabledComputers,DC=your,DC=domain,DC=com"
    # email team
    }
    $we = $oldies | Out-String
    Send-MailMessage -From '[]' -To '[]' -Subject "vintage OS shutdown" -body "$we" -smtp '[smtp]' 
    }

}

disable-vintageworkstations 
