provider "libvirt" {
  uri = "qemu:///system"
}

module "cloudd" {
  source = "github.com/ingobecker/cloudd"

  volume_dev = "/dev/vdb"
  root_dev   = "/dev/vda"
  context    = var.context
  user       = var.user
  ssh_key    = var.ssh_key
}

resource "libvirt_volume" "fedora32" {
  name   = "fedora32"
  source = var.fedora_url
  format = "qcow2"
  pool   = "default"
}

resource "libvirt_volume" "cloudd" {
  name           = "cloudd"
  base_volume_id = libvirt_volume.fedora32.id
  pool           = "default"
  format         = "qcow2"
  size           = var.storage_root * 1024 * 1024 * 1024
}

resource "libvirt_volume" "cloudd_ext_vol" {
  name   = "cloudd-ext-vol"
  pool   = "default"
  format = "qcow2"
  size   = var.storage_vol * 1024 * 1024 * 1024
}

resource "libvirt_cloudinit_disk" "cloudd" {
  name           = "cloudd-cloud-init.iso"
  user_data      = module.cloudd.cloud_init
  network_config = templatefile("${path.module}/network_config.cfg", {})
  pool           = "default"
}

resource "libvirt_domain" "cloudd" {
  name      = "cloudd"
  vcpu      = 1
  memory    = var.memory * 1024
  cloudinit = libvirt_cloudinit_disk.cloudd.id

  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.cloudd.id
  }

  disk {
    volume_id = libvirt_volume.cloudd_ext_vol.id
  }

  network_interface {
    network_name   = "default"
    wait_for_lease = true
  }
}

output "ssh_ip" {
  value       = libvirt_domain.cloudd.network_interface[0].addresses[0]
  description = "Reach your VM using this ip"
}
