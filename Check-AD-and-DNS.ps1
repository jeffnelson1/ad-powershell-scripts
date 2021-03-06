## Defining parameters

param (
    [Parameter(Mandatory)][string]$serverNames
)

## Parsing array syntax
$b = $serverNames -replace '["]', ''
$c = $b -replace '[]]', ''
$d = $c -replace '[[]', ''
$serverArray = $d.split(",")

## Loop to cycle through all server names in the $serverArray array to check if each server name exists in DNS and Active Directory.

foreach ($serverName in $serverArray) {

    ## Checking to see if hostname resides in DNS
    $dnsCheck = Test-Connection -ComputerName $servername -Quiet

    if ($dnsCheck) {
        Write-Output "[$serverName resolves in DNS.  Terminating deployment.  Please check DNS.]"
        throw "Script has been terminated."
    }

    else {
        Write-Output "[$serverName doesn't resolve in DNS, proceeding with build]" 
    }

    ## Checking to see if computer account resides in Active Directory

    Try {
        $adComputer = Get-ADComputer $serverName | Select-Object Name
        Write-Output "[$serverName exists in Active Directory, terminating script]"
        throw "Script has been terminated."
    }

    Catch {
        Write-Output "[$serverName doesn't exist in Active Directory, proceeding with build]"
    }

}
