Clear-Host
Write-Host "                                 .___       __                "
Write-Host "                 __ ________   __| _/____ _/  |_  ___________ "
Write-Host "                |  |  \____ \ / __ |\__  \\   __\/ __ \_  __ \"
Write-Host "                |  |  /  |_> > /_/ | / __ \|  | \  ___/|  | \/"
Write-Host "                |____/|   __/\____ |(____  /__|  \___  >__|   "
Write-Host "                      |__|        \/     \/          \/       "
Write-Host ""
Write-Host ""
Write-Host "Update Found, Updating ..."
Start-Sleep 2

Remove-Item ".\gui.ps1" -Force
Invoke-WebRequest "https://raw.githubusercontent.com/Aerodynamax/PowerShell-AntiVirus/main/gui.ps1" -OutFile ".\gui.ps1"
Remove-Item ".\threats.list" -Force
Invoke-WebRequest "https://raw.githubusercontent.com/Aerodynamax/PowerShell-AntiVirus/main/threats.list" -OutFile ".\threats.list"

Write-Host "Update Successful, Restarting Application ..."
Start-Sleep -Seconds 2
cmd.exe /c "powershell -Exec Bypass .\updater.ps1"; exit