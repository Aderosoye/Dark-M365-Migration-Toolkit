# Export SharePoint list
param (
    [string]$siteUrl = "https://darksystems120.sharepoint.com/sites/darkshare",
    [string]$listName = "ClientDirectory",
    [string]$exportPath = "C:\Users\a84302994\Documents\sss\Projects\M365-Migration-Sim\SharePoint\list\ClientDirectory.csv"
)

# Connect to SharePoint Online for source tenant
Write-Host "Connecting to Source Tenant..." -ForegroundColor Cyan
Connect-PnPOnline -Url $siteUrl -ClientId "6d06f645-7343-4d56-9e9a-a4ebc763c501" -Tenant "darksystems120.onmicrosoft.com" -Interactive

# Export the SharePoint list to CSV
Write-Host "Exporting SharePoint list '$listName' to '$exportPath'..." -ForegroundColor Cyan
$items = Get-PnPListItem -List $listName
if (-not $items) {
    Write-Error "No items found in the list '$listName'."
    exit
}

$exportData = foreach ($item in $items) {
    $fields = @{}
    $fieldValues = $item.FieldValues
    if ($fieldValues) {
        foreach ($key in $fieldValues.Keys) {
            if ($key -notmatch "^_|Attachment|GUID") {
                $fields[$key] = $fieldValues[$key]
            }
        }
    }
    [PSCustomObject]$fields
}

$exportData | Export-Csv -Path $exportPath -NoTypeInformation -Encoding UTF8
Write-Host "List exported successfully to '$exportPath'." -ForegroundColor Green