resource "libvirt_volume" "ubuntu" {
  name   = "ubuntu.qcow2"
  pool   = "images"
  source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-arm64.img"
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
    volume_id = libvirt_volume.ubuntu.id
  }

  network_interface {
    network_name = "hostbridge"
  }

    console {
    type        = "pty"
    target_type = "serial"
    target_port = 0
  }
}
