
$sourceParams = @{
    SourceSiteUrl = "https://yourtenant.sharepoint.com/sites/SourceSite"
    Library = "Documents"
    DownloadPath = "C:\SPMigration\Downloads"
    LogFile = "C:\SPMigration\export_log.csv"
}

$targetParams = @{
    TargetSiteUrl = "https://yourtargettenant.sharepoint.com/sites/TargetSite"
    Library = "Documents"
    UploadPath = "C:\SPMigration\Downloads"
    LogFile = "C:\SPMigration\upload_log.csv"
}

Write-Host "`n🔄 Starting Export from Source..." -ForegroundColor Yellow
& .\Export-From-Source.ps1 @sourceParams

Write-Host "`n🚀 Starting Upload to Target..." -ForegroundColor Yellow
& .\Upload-To-Target.ps1 @targetParams

Write-Host "`n📨 Generating Migration Summary..."
$exportLog = Get-Content $sourceParams.LogFile -Raw
$uploadLog = Get-Content $targetParams.LogFile -Raw
$summary = @"
MIGRATION COMPLETE

=== Export Log ===
$exportLog

=== Upload Log ===
$uploadLog
"@

$summaryPath = "C:\SPMigration\MigrationSummary.txt"
$summary | Out-File $summaryPath

# Optional: Email report (configure SMTP settings)
# Send-MailMessage -From "you@yourdomain.com" -To "admin@yourdomain.com" -Subject "SharePoint Migration Summary" -Body $summary -SmtpServer "smtp.yourserver.com"

Write-Host "`n✅ Migration Complete! Summary saved to $summaryPath" -ForegroundColor Green
