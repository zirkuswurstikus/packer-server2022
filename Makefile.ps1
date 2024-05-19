param (
    [string]$task
)

function Build {
    Write-Output "Running build task..."
    # Commands from build.ps1
    packer init .
    packer build .
    Write-Output "Build task completed."
}

function All {
    Write-Output "Running all task..."
    # Commands from test.ps1
    vagrant destroy -f
    vagrant box remove WINDOWS_SERVER2022_DC_BASE
    Remove-Item -Recurse ./vagrant
    vagrant box list
    vagrant box add WINDOWS_SERVER2022_DC_BASE_hyperv.box --name WINDOWS_SERVER2022_DC_BASE
    vagrant box list

    Start-Sleep 5

    # Uncomment if needed
    # vagrant init WINDOWS_SERVER2022_DC_BASE

    vagrant up

    vagrant powershell -c 'powershell -Command "Write-Output \"Hello from inside the VM!\" "'
    Write-Output "Test task completed."
}

function Cleanup {
    Write-Output "Running cleanup task..."
    # Commands from cleanup.ps1
    vagrant destroy -f
    Remove-Item -Recurse -Force .\.vagrant
    Remove-Item -Recurse -Force .\packer_cache
    Write-Output "Cleanup task completed."
}

switch ($task) {
    "build" {
        Build
        break
    }
    "all" {
        all
        break
    }
    "cleanup" {
        Cleanup
        break
    }
    default {
        Write-Output "Usage: .\Makefile.ps1 -task [build|test|cleanup]"
        exit 1
    }
}
