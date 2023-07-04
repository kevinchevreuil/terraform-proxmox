terraform {
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}
provider "proxmox" {
  # l'url /ip du proxmox sur lequel on se connecte on ajoute /api2/json
  pm_api_url = "https://146.59.110.145:8006/api2/json"
  # api token 
  pm_api_token_id = var.token_id
  # le token secret
  pm_api_token_secret = var.token_secret
  # pas de certificat ssl sur nos nodes donc en insecure
  pm_tls_insecure = true
}
# on cree une ressource proxmox_vm_qemu du nom de vm-terraform
resource "proxmox_vm_qemu" "vm-terra" {
  count = var.vm_count
#count = 2 
# 1 vm créer, 2 pour 2vm en apply
  name = var.vm_name 
#count.index commence a 0, + 1 = cette VM sera nommé vm-terraform-1 la suivante -2 
  # utilisation du fichier vars 
  target_node = var.proxmox_host
    # la variable contient "Template-Debian"
  clone = var.template_name
  # Parametre de base de la VM agent = guest agent
  agent = 1
  os_type = "cloud-init"
  cores = 2
  sockets = 1
  nameserver = "192.168.10.200"
  searchdomain = "exo-industries.xyz"
  cpu = "host"
  memory = 2048
  scsihw = "virtio-scsi-pci"
  bootdisk = "scsi0"
  disk {
    slot = 0
    # taille du disque du template et emplacement de celui-ci en local sur le nodes
    size = "20G"
    type = "scsi"
    storage = "exo-industries-ceph"
    iothread = 1
  }
  # le network en vmbr1
  network {
    model = "virtio"
    bridge = "vmbr1"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
}
  # a ameliorer le plan d'assignement ip sinon vm utilisera le dhcp 
  ipconfig0 = "ip=${var.ip_vm}/24,gw=${var.ip_range}.1"  

}
