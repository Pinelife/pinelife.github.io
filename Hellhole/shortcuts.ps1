param([String]$command)

switch ($command)
{
    'setup' {
        Write-Host "Setting up Hellhole environment...`n"
        # TODO
        # install Chocolatey
        # install Python
        # install Git
        # Setup Git remote
        if (-Not (Test-Path ./scripts/env/)) {
            Write-Host "Setting up Python virtual environment"
            virtualenv ./scripts/env/            
        }
        Write-Host "Installing Python requirements"
        ./scripts/env/scripts/activate
        pip install -r ./scripts/requirements.txt
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