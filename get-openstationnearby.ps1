# need to check something on specific hardware in a specific lab defined by OU?
# feed in the hostname of a known computer, distinguised name is then used to quickly run quser on other hosts in the OU

function get-openstationnearby {
    param ($goods)

    $labinquestion = get-adcomputer $goods

    $thegoods = $labinquestion.DistinguishedName -split "^[^,]*,", ""

    $wslist = Get-ADComputer -Filter * -SearchBase "$thegoods" | Sort-Object Name

    foreach ($ws in $wslist) {
        $whatdude = $ws.Name
        $test = Test-Connection -ComputerName $whatdude -quiet -Count 1
            IF ($test -eq $false){
                Write-Host "$whatdude is not reachable." -BackgroundColor "red"
                }

            else {

                $stuffing = quser /SERVER:$whatdude | Out-string

                if ($stuffing -eq "$null") {
                    Write-host "$whatdude is available" -ForegroundColor "green"
                    }
            }
    }
}
# SYNTAX
# get-openstationnearby LabComputer1