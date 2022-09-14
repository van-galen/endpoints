# Adapted and passed down from many other helpful folks. This script will toss a file or folder on each endpoint that is reachable in an OU.

function copy-fileOU($OU,$localPath,$remotePath){
    $hostnames=$null
    # get list of hostnames in OU
    $hostnames = Get-ADComputer -SearchBase $OU -Filter * | Select -ExpandProperty Name
    if (!(Test-Path $localPath -ErrorAction SilentlyContinue)) {
        Write-Host "The specified source file was not found." -ForegroundColor Red
        break
        } 
    Write-Host "Source File: $localPath" 
    Write-Host "Target OU  : $OU"
    Write-Host "-----------------------------------------------------------------------"
    Write-Host ""

    foreach ($pc in $hostnames){
        $TargetPath = $NULL
        $TargetPath = "Microsoft.Powershell.Core\FileSystem::\\$pc\C$"
        # target pc, test if up
        if(Test-Connection -Count 1 -BufferSize 15 -Delay 1 -ComputerName $pc -ErrorAction SilentlyContinue){
            # pc is up, test if path is valid
            if (Test-Path $TargetPath){
                # pc is up, path is valid, copy file
                Write-Host "Copying file on $PC" -ForegroundColor Cyan
                Write-Host "Target Path: \\$pc\$remotePath"
                Write-Host ""
                Copy-Item -Path $localPath -Destination "Microsoft.Powershell.Core\FileSystem::\\$pc\$remotePath" -Recurse #-WhatIf
                }
            else{Write-Host "Path is not valid on $pc." -ForegroundColor Red}
        }
        else {Write-Host "$pc not responding." -ForegroundColor Yellow; Write-Host ""}
    }
}

# SYNTAX
# copy-fileOU "OU=ComputerLab,DC=your,DC=AD,DC=domain" "C:\TEMP\FILE-TO-COPY.txt" "C$\Destination\Folder"