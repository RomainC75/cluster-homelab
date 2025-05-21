resource "libvirt_volume" "ubuntu_iso" {
  name   = "ubuntu.qcow2"
  pool   = "images"
  # source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-arm64.img"
  # source = "https://cdimage.ubuntu.com/releases/22.04.5/release/ubuntu-22.04.5-live-server-arm64.iso"
  source = "/Users/romainchenard/Work/gitops/homelab/cluster-homelab/infra/terraform-libvirt/prepped-ubuntu.qcow2"

  format = "qcow2"
}




resource "libvirt_domain" "vm" {
  name   = "master"
  memory = "12000"
  vcpu   = 7

  cpu {
    mode = "host-passthrough"
  }

  disk {
    volume_id = libvirt_volume.ubuntu_iso.id
  }

  network_interface {
    network_name = "hostbridge"
    mac          = var.mac_addr
  }

    console {
    type        = "pty"
    target_type = "serial"
    target_port = 0
  }
}
