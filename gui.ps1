$virus_filenames = @()
$quarentine_list = @()
$gui_file = [System.IO.File]::ReadLines('.\gui.ps1')
$threat_file = [System.IO.File]::ReadLines('.\gui.ps1')

foreach($line in [System.IO.File]::ReadLines('.\threats.list'))
{
    $virus_filenames += $line
}
function Logo {
    Clear-Host
    Write-Host "__________                           _________.__           .__  .__    "
    Write-Host "\______   \______  _  __ ___________/   _____/|  |__   ____ |  | |  |   "
    Write-Host " |     ___/  _ \ \/ \/ // __ \_  __ \_____  \ |  |  \_/ __ \|  | |  |   "
    Write-Host " |    |  (  <_> )     /\  ___/|  | \/        \|   Y  \  ___/|  |_|  |__ "
    Write-Host " |____|   \____/ \/\_/  \___  >__| /_______  /|___|  /\___  >____/____/ "
    Write-Host "                            \/             \/      \/     \/            "
    Write-Host "   _____          __  .______   ____.__                                 "
    Write-Host "  /  _  \   _____/  |_|__\   \ /   /|__|______ __ __  ______            "
    Write-Host " /  /_\  \ /    \   __\  |\   Y   / |  \_  __ \  |  \/  ___/            "
    Write-Host "/    |    \   |  \  | |  | \     /  |  ||  | \/  |  /\___ \             "
    Write-Host "\____|__  /___|  /__| |__|  \___/   |__||__|  |____//____  >            "
    Write-Host "        \/     \/                                        \/             "
    Write-Host ""
    Write-Host ""
}
function Startup {
    Logo
    Start-Sleep -Seconds 4
    Write-Host "Checking For Updates ..."
    
    if(!((Invoke-WebRequest "https://raw.githubusercontent.com/Aerodynamax/PowerShell-AntiVirus/main/gui.ps1").Content -eq $gui_file -or ((Invoke-WebRequest "https://raw.githubusercontent.com/Aerodynamax/PowerShell-AntiVirus/main/threats.list").Content -eq $threat_file))){cmd.exe /c "powershell -Exec Bypass .\updater.ps1"; exit}
    else{
        Write-Host "No Updates Found, Continuing boot ..."
        Start-Sleep -Seconds 1
        Menu
    }
}
function Menu {
    Logo
    Write-Host "1)>    QuickScan"
    Write-Host "2)>    FullScan"
    Write-Host "3)>    FolderScan"
    Write-Host "4)>    Exit"
    Write-Host ""
    Choose
}
function Choose {
    $choice = (Read-Host "PSAV")
    if($choice -eq "1"){Scan $pwd quick; cmd.exe /c pause; Menu}
    elseif($choice -eq "2"){Scan $pwd full; cmd.exe /c pause; Menu}
    elseif($choice -eq "3"){FolderScan}
    elseif($choice -eq "4"){exit}
    else {
        Write-Host "Invalid Option :-("
        Start-Sleep -Seconds 1
        Choose
    }
}
function Scan {
    param ( [string]$CurrPath, [string]$ScanType, [string]$ScanFolder )

    if($ScanType -eq 'quick'){$Path = "$env:HOMEPATH"}elseif($ScanType -eq 'full'){$Path = $env:HOMEDRIVE+'\'}elseif($ScanType -eq 'folder'){$Path = $ScanFolder}else {Write-Host 'invalid Scan type :-(';exit}

    Write-Host 'Starting Scan Type:'$ScanType

    # Do Windows Scans In Background
    Write-Host 'starting background windows scans ...'

    $win = Start-Job {cmd.exe /c 'sfc /scannow'}

    # Do Windows Scans In Background

    # Collect Files
    Write-Host 'Collecting Files ...'
    $files = Get-Childitem $Path -Recurse -File -Name
    # Collect Files

    # Scan Files
    Write-Host 'Scanning Files ...'

    Write-Host 'Scanning: '($files).count' Files'
    Write-Host '1%: '((($files).count)/100)' Files'

    For($i = 1; $i -le $virus_filenames.count; $i++){
        $virus_filename = $virus_filenames[$i]
        Write-Progress -Activity 'Scanning Files' -status "Checking For File: $virus_filename" -percentComplete ($i / ($virus_filenames).count * 100);
        
        if($files -contains (($virus_filenames)[$i])){
            Write-Host "Detected:" $virus_filenames[$i]
            $quarentine_list += (($virus_filenames)[$i])
        }

        #(($files).Name)[$i]
    }
    $i = 0
    # Scan 


    # Output

    Write-Host '=============='
    Write-Host ' SCAN CONTEXT'
    Write-Host '=============='
    Write-Host 'Windows Background Scan:'
    Write-Host ($win).Output
    Write-Host 'Infected:'
    Write-Host $quarentine_list
    Write-Host '=============='

    Start-Sleep -Seconds 3

    # Output
    $win.StopJob()
        
}
function FolderScan {
    $ScanFolder = Read-Host "Enter Exact Folder Path"
    if(Test-Path -Path $ScanFolder){
        Scan $pwd folder $ScanFolder; cmd.exe /c pause; Menu  
    }
    else {
        if((Read-Host "Invalid Folder, {c to contiue | e to return to main menu}") -eq "c"){
            FolderScan
        }
        else {
            Menu
        }
    }  
}

Startup