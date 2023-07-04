variable "proxmox_host" {
  #    default = "node3"
  description = "le node ou on va placer les vm"
}
variable "template_name" {
  default = "Template-Debian-Packer"
}
variable "ip_range" {
  description = "l'addresse ip de la vm"
  default     = "192.168.10"
}
variable "ip_vm" {
  description = "l'addresse ip de la vm"
  #  default     = "192.168.10.70"
}
variable "vm_count" {
  description = "nombre de vm que l'on veut créer"
  type        = number
}

variable "vm_name" {
  description = "le nom de la vm"
  #default = "vm-terraform"
}
