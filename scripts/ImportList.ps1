# ------------------------------------------------------------
# Elite SharePoint CSV Importer – Dark👣 Systems
# ------------------------------------------------------------
param (
    [string]$siteUrl    = "https://adroyphillgmail.sharepoint.com/sites/darkshare",
    [string]$listName   = "ClientDirectory",
    [string]$importPath = "C:\Users\a84302994\Documents\sss\Projects\M365-Migration-Sim\SharePoint\list\ClientDirectory.csv"
)

# 1) Connect
Write-Host "🔗 Connecting to $siteUrl…" -ForegroundColor Cyan
Connect-PnPOnline -Url $siteUrl -ClientId "e0c53ce0-9add-42e9-bffb-e5cbd71c0147" -Tenant "adroyphillgmail.onmicrosoft.com" -Interactive

# 2) Load CSV
if (-not (Test-Path $importPath)) {
    Write-Error "❌ CSV not found at $importPath"; exit
}
$data    = Import-Csv -Path $importPath
$headers = $data[0].PSObject.Properties.Name
Write-Host "📊 Found CSV columns: $($headers -join ', ')" -ForegroundColor Gray

# 3) Ensure list exists
if (-not (Get-PnPList -Identity $listName -ErrorAction SilentlyContinue)) {
    Write-Host "📁 Creating list '$listName'…" -ForegroundColor Yellow
    New-PnPList -Title $listName -Template GenericList -OnQuickLaunch
}

# 4) Auto-create all CSV headers as Text fields
$existing = (Get-PnPField -List $listName).InternalName
foreach ($col in $headers) {
    if ($existing -notcontains $col) {
        Write-Host "➕ Adding Text field '$col'" -ForegroundColor Cyan
        Add-PnPField -List $listName -DisplayName $col -InternalName $col -Type Text
    }
}

# refresh field list
$existing = (Get-PnPField -List $listName).InternalName

# 5) Import each row
$imported = 0
foreach ($row in $data) {
    $values = @{}

    foreach ($col in $headers) {
        $val = $row.$col
        if ($val -and $existing -contains $col) {
            $values[$col] = $val
        }
    }

    if ($values.Count -gt 0) {
        try {
            Add-PnPListItem -List $listName -Values $values
            $imported++
        } catch {
            # <<— fixed interpolation here using ${imported}
            Write-Warning "Failed to import row #${imported}: $($_.Exception.Message)"
        }
    }
}

# 6) Report
Write-Host "✅ Imported $imported items into '$listName'." -ForegroundColor Green