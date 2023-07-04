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
variable "token_id" {
   description = "l'utilisateur terraform afin de se connecter"
   type        = string
   sensitive   = true   
}

variable "token_secret" {
   description = "le secret de l'utilisateur terraform"
   type        = string
   sensitive   = true

}
