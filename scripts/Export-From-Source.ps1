
param (
    [string]$SourceSiteUrl = "https://yourtenant.sharepoint.com/sites/SourceSite",
    [string]$Library = "Documents",
    [string]$DownloadPath = "C:\SPMigration\Downloads",
    [string]$LogFile = "C:\SPMigration\export_log.csv"
)

function Download-FilesRecursive {
    param (
        [string]$folderUrl,
        [string]$localPath
    )

    $items = Get-PnPFolderItem -FolderSiteRelativeUrl $folderUrl

    foreach ($item in $items) {
        $retry = 0
        $maxRetry = 3
        $success = $false

        if ($item.FileSystemObjectType -eq "Folder") {
            $subFolder = Join-Path $localPath $item.Name
            if (-not (Test-Path $subFolder)) { New-Item -Path $subFolder -ItemType Directory | Out-Null }
            Download-FilesRecursive -folderUrl "$folderUrl/$($item.Name)" -localPath $subFolder
        }
        elseif ($item.FileSystemObjectType -eq "File") {
            $targetPath = Join-Path $localPath $item.Name

            if (Test-Path $targetPath) {
                $localTime = (Get-Item $targetPath).LastWriteTime
                $remoteTime = $item.TimeLastModified
                if ($remoteTime -le $localTime) { return }
            }

            while (-not $success -and $retry -lt $maxRetry) {
                try {
                    Write-Host "⬇️  Downloading $($item.Name)..."
                    Get-PnPFile -Url $item.ServerRelativeUrl -Path $localPath -FileName $item.Name -AsFile -Force
                    "$($item.Name),$($item.ServerRelativeUrl),$([DateTime]::Now),Success" | Out-File -Append -FilePath $LogFile
                    $success = $true
                } catch {
                    $retry++
                    Start-Sleep -Seconds 2
                    if ($retry -eq $maxRetry) {
                        "$($item.Name),$($item.ServerRelativeUrl),$([DateTime]::Now),Failed: $_" | Out-File -Append -FilePath $LogFile
                    }
                }
            }
        }
    }
}

if (-not (Test-Path $DownloadPath)) { New-Item -ItemType Directory -Path $DownloadPath | Out-Null }
if (Test-Path $LogFile) { Remove-Item $LogFile -Force }
"FileName,URL,DownloadedAt,Status" | Out-File -FilePath $LogFile

Connect-PnPOnline -Url $SourceSiteUrl -Interactive
Download-FilesRecursive -folderUrl $Library -localPath $DownloadPath
Compress-Archive -Path "$DownloadPath\*" -DestinationPath "$DownloadPath\Archive.zip" -Force
