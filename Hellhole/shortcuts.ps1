param([String]$command)

function IsInstalled {
    param([String]$cmd)
    $ErrorActionPreference = "SilentlyContinue"
    $installed =  Get-Command $cmd
    $ErrorActionPreference = "Stop"
    return $cmd
}

switch ($command) {
    'setup' {
        Write-Host "Setting up Hellhole environment...`n"
        $ErrorActionPreference = "Stop"

        # You may have to run this manually
        Write-Host "Applying 'RemoteSigned' execution policy."
        Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

        # Install Chocolatey package manager
        if(!(IsInstalled choco)) 
        {
            Write-Host "Installing Chocolatey package manager."
            # Download and run install script
            $ChocoURL = 'https://chocolatey.org/install.ps1'
            Invoke-WebRequest $ChocoURL -UseBasicParsing | Invoke-Expression
            # Load Chocolatey environment variables
            RefreshEnv
        }

        # Install git
        if (!(IsInstalled git)) {
            choco install git -y
            # Setup Git remote?
        }

        # Install Python 2.7
        if (!(IsInstalled python)) {
            choco install python2 -y
        }

        # Refresh PATH environment variable
        $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine")

        if (!(IsInstalled virtualenv)) {
            pip install virtualenv
        }

        if (-Not (Test-Path ./scripts/env/)) {
            Write-Host "Setting up Python virtual environment"
            virtualenv ./scripts/env/            
        }
        Write-Host "Installing Python requirements"
        ./scripts/env/scripts/activate
        pip install -r ./scripts/reqs.txt
        Write-Host "Done!"
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