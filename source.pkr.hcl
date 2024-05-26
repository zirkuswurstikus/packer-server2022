packer {
  required_plugins {
    hyperv = {
      source  = "github.com/hashicorp/hyperv"
      version = "~> 1"
    }
  }
}



// TODO: use ./scripts/*
// TODO: templating for Autounattend.xml
source "hyperv-iso" "hyperv" {
  boot_command                      = ["a<wait2>a<wait2>a<wait2>a<wait2>a"]
  boot_wait                         = "2s"
  communicator                      = "winrm"
  configuration_version             = "9.0" //"10.0"
  cpus                              = "${var.cpus}"
  memory                            = "${var.memory}"
  disk_size                         = "${var.disk_size}"
  enable_dynamic_memory             = false
  enable_mac_spoofing               = true
  enable_secure_boot                = true
  enable_tpm                        = true
  enable_virtualization_extensions  = true
  generation                        = "2"
  guest_additions_mode              = "disable"
  iso_checksum                      = "${var.iso_checksum}"
  iso_url                           = "${var.iso_url}"
  # drive E:
  secondary_iso_images              = "ressources/empty.iso"
  # secondary_iso_images				      = ["C:/wsusoffline/iso/wsusoffline-w100-x64.iso"] //[E:\] if removed the path for cd_files should be changed back to e: 
  # drive F:
  cd_files                          = [
                                      "./ressources/configs/autounattend.xml",
                                      "./ressources/configs/autounattend_sysprep.xml",
									                    "./ressources/scripts/Enable-Winrm.ps1"
                                    ]
  //shutdown_command                  = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\""
  shutdown_command                  = "C:\\Windows\\system32\\Sysprep\\sysprep.exe /generalize /oobe /shutdown /unattend:F:\\autounattend_sysprep.xml"  
  shutdown_timeout                  = "60m"
  switch_name                       = "${var.switchname}"
  vm_name                           = "${var.vm_name}"
  winrm_password                    = "vagrant"
  winrm_username                    = "vagrant"
  winrm_timeout                     = "6h"
  disable_shutdown					        = false // FOR DEBUGGING
  skip_export						            = false // no .box, keep vhd(x)
  output_directory					        = "./out"
}

build {
  sources = ["source.hyperv-iso.hyperv"]
  
  provisioner "breakpoint" {
	note 		= "Breakpoint BEFORE windows-restart"
	disable		= true
	}

  // UPDATE WINDOWS
  // use wsusoffline
  // currently no WIN11 updates with wsusoffline available
  # provisioner "windows-shell" {
  #     inline = ["E:/cmd/DoUpdate.cmd"]
  #     valid_exit_codes = [
  #       1,
  #       3010, # reboot required
  #       3011,
  #       3015
  #     ]
  # }
  # provisioner "windows-restart" {}

  provisioner "powershell" {
    scripts = ["ressources/scripts/Update-WindowsOnline.ps1"]
  }
  provisioner "windows-restart" {}

  provisioner "powershell" {
    scripts = ["ressources/scripts/Cleanup-Windows.ps1"]
  }

  provisioner "windows-restart" {
    restart_timeout = "30m"
  }

  post-processor "vagrant" {
    keep_input_artifact  = false	// DEFAULT false
    output               = "./out/WINDOWS_SERVER2022_DC_BASE_{{ .Provider }}.box"
    vagrantfile_template = "ressources/configs/WINDOWS_SERVER2022_DC_BASE.vagrantfile.template"
  }

}
