# Configuration section
$targetSiteUrl = "https://adroyphillgmail.sharepoint.com/sites/darkshare"
$targetLibrary = "Shared Documents"
$localDownloadPath = "C:\Users\a84302994\Documents\sss\Projects\M365-Migration-Sim\SharePoint\data"

# Connect to SharePoint Online for target site
Connect-PnPOnline -Url $targetSiteUrl -ClientId "e0c53ce0-9add-42e9-bffb-e5cbd71c0147" -Tenant "adroyphillgmail.onmicrosoft.com" -Interactive

# Upload files to SharePoint library for the target site
$files = Get-ChildItem -Path $localDownloadPath
foreach ($file in $files) {
    $serverRelativeTarget = "$targetLibrary/$($file.Name)"

    Write-Host "Uploading $($file.Name) to $targetLibrary..." -ForegroundColor Cyan
    Add-PnPFile -Path $file.FullName -Folder $targetLibrary -Values @{}
}

Write-Host "`nUpload complete. Files uploaded to: $targetLibrary on $targetSiteUrl" -ForegroundColor Green