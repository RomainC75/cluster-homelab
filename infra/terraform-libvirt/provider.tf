terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
#   uri = "qemu:///system"
  uri = "qemu+ssh://ubuntu@op5/system"
}