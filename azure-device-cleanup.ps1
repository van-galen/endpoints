$cloudcred = $null
$cloudcred = import-CliXml -path "[cred.xml]"
Connect-AzureAD -Credential $cloudcred

#AZURE AD CLEANUP
function azure-device-cleanup ($filepath,$disdate,$deldate) {

    $disable = (Get-Date).AddDays($disdate)
    $delete = (Get-Date).AddDays($deldate)

    # set stale devices disabled
    Get-AzureADDevice -All:$true | Where {($_.ApproximateLastLogonTimeStamp -le $disable) -and ($_.AccountEnabled -eq $true)} | select DisplayName,DeviceId,objectID,ApproximateLastLogonTimeStamp | Set-AzureADDevice -AccountEnabled $false

    # delete the really stale disabled devices
    $ancientAZ = Get-AzureADDevice -All:$true | Where {($_.ApproximateLastLogonTimeStamp -le $delete) -and ($_.AccountEnabled -eq $false)} | select DisplayName,DeviceId,objectID,ApproximateLastLogonTimeStamp | sort DisplayName

    $ancientAZ | export-csv -Path $filepath -append

         foreach ($elder in $ancientAZ){
             Remove-AzureADDevice -ObjectId $elder.objectID
         }
		 
	$we = $ancientAZ.count | Out-String
    
    # alert if you want to
    # Send-MailMessage -From '[]' -To '[]' -Subject "AAD Cleanup function ran" -body "$we" -smtp '[]' 	
}

# RUNNING THE FUNCTIONS
# azure-device-cleanup D:\cool-path\ancient-azure-log.csv -365 -405
