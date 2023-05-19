
# AD CLEANUP
function delete-stale ($logpath) {
    
    $405days = (Get-Date).AddDays(-405) 

    # there are certainly smarter things one can do, but if you need to log ms-Mcs-AdmPwd snag it in the get-adcomputer

    $veryolds = Get-ADComputer -Property Name,lastLogonDate,Enabled,OperatingSystem,samaccountname -searchbase "OU=DisabledComputers,DC=your,DC=domain,DC=com" -Filter {
        lastLogonDate -lt $405days -and 
        (OperatingSystem -notlike 'windows*server*' -and OperatingSystem -like '*Windows*')}  | select samaccountname | sort samaccountname
    
    if ($veryolds -ne $null){
        #export name and password to file
        $veryolds | Out-File -FilePath "$logpath" -Append

        foreach ($old in $veryolds){    
        #delete object
        # this fails if leaf objects exists
        # Remove-ADComputer -Identity $old.samaccountname -confirm:$false #-WhatIf
        # this angers me but works
        get-adcomputer -Identity $old.samaccountname | Remove-ADObject -Recursive -Confirm:$false 

     }
    
	# [alert if you want to]
	}

}  


# RUNNING THE FUNCTIONS
# delete-stale D:\path\ancient-log.txt
