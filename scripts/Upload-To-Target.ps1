
param (
    [string]$TargetSiteUrl = "https://yourtargettenant.sharepoint.com/sites/TargetSite",
    [string]$Library = "Documents",
    [string]$UploadPath = "C:\SPMigration\Downloads",
    [string]$LogFile = "C:\SPMigration\upload_log.csv"
)

function Upload-FilesRecursive {
    param (
        [string]$localPath,
        [string]$sharePointFolder
    )

    Get-ChildItem -Path $localPath | ForEach-Object {
        $retry = 0
        $maxRetry = 3
        $success = $false

        if ($_.PSIsContainer) {
            $newFolder = "$sharePointFolder/$($_.Name)"
            Ensure-PnPFolder -SiteRelativePath $newFolder -Folder $Library | Out-Null
            Upload-FilesRecursive -localPath $_.FullName -sharePointFolder $newFolder
        }
        else {
            while (-not $success -and $retry -lt $maxRetry) {
                try {
                    Write-Host "⬆️  Uploading $($_.Name) to $sharePointFolder"
                    Add-PnPFile -Path $_.FullName -Folder $sharePointFolder -Values @{}
                    "$($_.Name),$sharePointFolder/$($_.Name),$([DateTime]::Now),Success" | Out-File -Append -FilePath $LogFile
                    $success = $true
                } catch {
                    $retry++
                    Start-Sleep -Seconds 2
                    if ($retry -eq $maxRetry) {
                        "$($_.Name),$sharePointFolder/$($_.Name),$([DateTime]::Now),Failed: $_" | Out-File -Append -FilePath $LogFile
                    }
                }
            }
        }
    }
}

if (Test-Path $LogFile) { Remove-Item $LogFile -Force }
"FileName,URL,UploadedAt,Status" | Out-File -FilePath $LogFile

Connect-PnPOnline -Url $TargetSiteUrl -Interactive
Upload-FilesRecursive -localPath $UploadPath -sharePointFolder $Library
