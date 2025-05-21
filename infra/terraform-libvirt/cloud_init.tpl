#cloud-config
users:
  - name: rom
    ssh-authorized-keys:
      - ${public_key}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash