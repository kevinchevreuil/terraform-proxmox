terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
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
  count        = var.vm_count
  name         = var.vm_name
  vmid         = var.vm_id
  target_node  = var.proxmox_host
  clone        = var.template_name
  agent        = 1
  os_type      = "cloud-init"
  cores        = 1
  sockets      = 1
  nameserver   = "8.8.8.8"
  searchdomain = "localdomain"
  cpu          = "host"
  memory       = 1024
  scsihw       = "virtio-scsi-pci"
  bootdisk     = "scsi0"
  disk {
    slot = 0
    # taille du disque du template et emplacement de celui-ci en local sur le nodes
    size    = "20G"
    type    = "scsi"
    storage = "exo-industries-ceph"
  }
  # le network en vmbr1
  network {
    model  = "e1000"
    bridge = "vmbr1"
  }
  lifecycle {
    ignore_changes = [
      network,
    ]
  }
  # a ameliorer le plan d'assignement ip sinon vm utilisera le dhcp 
  ipconfig0 = "ip=${var.ip_vm}/24,gw=${var.ip_range}.1"

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook --ssh-common-args '-o StrictHostKeyChecking=no' --become --become-user root --become-method sudo --private-key $HOME/.ssh/id_rsa -u projet -i inventory playbooks/${var.vm_name}.yml"
  }
}
