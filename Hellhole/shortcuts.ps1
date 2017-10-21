param([String]$command)

function IsInstalled {
    param([String]$cmd)
    $ErrorActionPreference = "Ignore"
    $installed =  Get-Command $cmd
    $ErrorActionPreference = "Stop"
    return $cmd
}

switch ($command) {
    'setup' {
        Write-Host "`nSetting up Hellhole environment..."
        $ErrorActionPreference = "Stop"

        # You may have to run this manually
        Write-Host "`nApplying 'RemoteSigned' execution policy."
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

        # Install Chocolatey package manager
        if(!(IsInstalled choco)) {
            Write-Host "`nInstalling Chocolatey package manager."
            # Download and run install script
            $ChocoURL = 'https://chocolatey.org/install.ps1'
            Invoke-WebRequest $ChocoURL -UseBasicParsing | Invoke-Expression
            # Load Chocolatey environment variables
            RefreshEnv
        } else {
            Write-Host "`nChocolatey is already installed"
        }

        # Install git
        if (!(IsInstalled git)) {
            Write-Host "`nInstalling Git"
            choco install git -y
            # Setup Git remote?
        } else {
            Write-Host "`nGit is already installed"
        }

        # Install Python 2.7
        if (!(IsInstalled python)) {
            Write-Host "`nInstalling Python"
            choco install python2 -y
        } else {
            Write-Host "`nPython is already installed"
        }

        # Refresh PATH environment variable
        $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine")

        if (!(IsInstalled virtualenv)) {
            Write-Host "`nInstalling Virtualenv"
            pip install virtualenv
        } else {
            Write-Host "`nVirtualenv is already installed"
        }

        if (-Not (Test-Path ./scripts/env/)) {
            Write-Host "`nSetting up Python virtual environment"
            virtualenv ./scripts/env/            
        } else {
            Write-Host "`nVirtual environment already set up"
        }

        Write-Host "`nInstalling Python requirements"
        ./scripts/env/scripts/activate
        pip install -r ./scripts/reqs.txt
        Write-Host "`nDone!`n"
    }
    'build' {
        Write-Host "Building Hellhole...`n"
        ./scripts/env/scripts/activate
        python ./scripts/build.py
    }
    'push' {
        Write-Host "Pushing Hellhole to GitHub...`n"
        git add .
        git commit -m "Auto commit"
        git push
        Write-Host "`nDone!`n"
    }
    'lint' {
        Write-Host "Formatting source HTML...`n"
        ./scripts/env/scripts/activate
        ForEach ($file in (Get-ChildItem .\source\)) {
            $path = Join-Path .\source\ $file
            python ./scripts/env/Scripts/html5-print $path
        }
    }
    default {
        Write-Host "`n`tHellhole Shortcuts`n"
        Write-Host "`tsetup    -    setup working environment"
        Write-Host "`tbuild    -    build HTML from source"
        Write-Host "`tpush     -    push changes to GitHub"
        Write-Host "`n`tExample use:`n`n`t./shortcuts.ps1 build"
        Write-Host

    }
} 