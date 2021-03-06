## Defining parameters

param (
    [Parameter(Mandatory)][string]$serverNames,
    [Parameter(Mandatory)][string]$adDescription
)

## Parsing array syntax
$b = $serverNames -replace '["]', ''
$c = $b -replace '[]]', ''
$d = $c -replace '[[]', ''
$serverArray = $d.split(",")

## Adding server to a patching group
$patchGroupArray = @("Group1",
    "Group2")

$patchGroupCounts = @()

foreach ($group in $patchGroupArray) {

    $count = (Get-ADGroupMember $group).count
    
    $patchGroupCounts += New-Object -TypeName psobject -Property @{PatchGroupName = $group; MemberCount = $count }

}

$patchGroupsSorted = $patchGroupCounts | Sort-Object -Property MemberCount

$patchGroupsSorted += $patchGroupsSorted += $patchGroupsSorted += $patchGroupsSorted

$namesOrdered = ($patchGroupsSorted).PatchGroupName

$i = 0

## Loop through each server name to add server to a patch group and add an AD description
foreach ($servername in $serverArray) {

    Add-ADGroupMember $namesOrdered[$i] -members "$servername$" -Credential $domainUserCreds -Verbose
    Start-Sleep -s 5
    Write-Output "[$servername has been added to a patch group]"

    $i++

    Set-ADComputer $servername -Description $adDescription -Credential $domainUserCreds -Verbose
    Write-Output "[AD Description for $servername has been added]"
    Start-Sleep -s 5

}
