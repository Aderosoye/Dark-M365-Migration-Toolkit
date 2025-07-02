# PowerShell Script: Upload test data to OneDrive for multiple users
# NOTE: Requires MS Graph API and proper permissions
# This is a simulation script; adjust client_id, tenant_id, and token handling fot real use

$users = @(
    @{ Email = "alice@darksystems120.onmicrosoft.com"; Folder = "AliceFiles" },
    @{ Email = "AyobamideleAderosoye@darksystems120.onmicrosoft.com"; Folder = "AyoFiles" }
    @{ Email = "bob@darksystems120.onmicrosoft.com"; Folder = "BobFiles" }
)

foreach ($user in $users) {
    Write-Host "Simulating upload for user: $($user.Email)"
    $folderPath = "C:\Users\a84302994\Documents\sss\Projects\M365-Migration-Sim\testdata\$($user.Folder)"
    New-Item -ItemType Directory -Force -Path $folderPath

    # Simulate file creation
    1..3 | ForEach-Object {
        $fileName = "Sample_File_$_.txt"
        $filePath = Join-Path $folderPath $fileName
        "This is a test file for $($user.Email), File $_" | Out-File -FilePath $filePath
    }
    Write-Host "Created sample files at $folderPath`n"
}

Write-Host "Test data folders and files created locally. Upload to OneDrive manually or via Graph API/OneDrive SDK."