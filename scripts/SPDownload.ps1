# Configouration section
$libraryName = "Shared Documents"
$localDownloadPath = "C:\Users\a84302994\Documents\sss\Projects\M365-Migration-Sim\SharePoint\data"
 # Get files in library
 $files = Get-PnPFolderItem -FolderSiteRelativeUrl $libraryName -ItemType File
 foreach ($file in $files) {
    $serverRelativeUrl = $file.ServerRelativeUrl
    $filename = Split-Path -Path $serverRelativeUrl -Leaf
    $targetPath = Join-Path -Path $localDownloadPath -ChildPath $filename

    Write-Host "Downloading $filename..." -ForegroundColor Cyan
    Get-PnPFile -Url $serverRelativeUrl -Path $localDownloadPath -FileName $filename -AsFile -Force
 }

 Write-Host "`nDownload complete. Files saved to: $localDownloadPath" -ForegroundColor Green