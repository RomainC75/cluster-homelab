terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.7.6"
    }
  }
}

provider "libvirt" {
  # Configuration du fournisseur libvirt
  uri = "qemu:///system"
}

terraform {
  required_version = ">= 1.6.6"
}