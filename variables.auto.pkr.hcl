variable "cpus" {
  type    = string
  default = "4" // default: "2"
}

variable "disk_size" {
  type    = string
  default = "262144"
}

variable "headless" {
  type    = string
  default = "false"
}

variable "iso_checksum" {
  type    = string
  default = "sha256:3E4FA6D8507B554856FC9CA6079CC402DF11A8B79344871669F0251535255325"
}

variable "iso_url" {
  type    = string
  # Windows Server 2022 EN-US
  default = "https://software-static.download.prss.microsoft.com/sg/download/888969d5-f34g-4e03-ac9d-1f9786c66749/SERVER_EVAL_x64FRE_en-us.iso"
}

variable "memory" {
  type    = string
  default = "4096" // default "4096"
}

variable "vm_name" {
  type    = string
  default = "WINDOWS_SERVER2022_DC_BASE" //CHANGEME
}

variable "switchname" {
  type = string
  default = "Default Switch" // use an external switch on Windows Server
}