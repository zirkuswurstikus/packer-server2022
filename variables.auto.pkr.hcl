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
  default = "none"
}

variable "iso_url" {
  type    = string
  default = "../iso/Windows_2022.iso"
}

variable "memory" {
  type    = string
  default = "4096" // default "4096"
}

variable "vm_name" {
  type    = string
  default = "WINDOWS_SERVER2022_DC_BASE" //CHANGEME
}