variable "pool_name" {
    default = "images"
}

variable "hostname" { default = "master" }
variable "domain" { default = "example.com" }
variable "ip_type" { default = "dhcp" } # dhcp is other valid type
variable "memoryMB" { default = 1024*12 }
variable "cpu" { default = 7 }
variable "disk_size_gb" { default = 15 }

variable "mac_addr" {type = string}