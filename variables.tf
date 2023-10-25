variable "flavor_name" {
  default = [
    "d1.ram1cpu1",
    "d1.ram2cpu1",
    "d1.ram4cpu2",
    "d1.ram8cpu2",
    "d1.ram8cpu4",
  ]
}

variable "cidr" {
  default = ["192.168.10.0/24"]
}

variable "external_network_id" {
  default = "83554642-6df5-4c7a-bf55-21bc74496109"
}

variable "pool" {
  default = "FloatingIP Net"
}

variable "volume_type" {
  default = [
    "ceph-ssd",
    "ceph-hdd",
    "ceph-backup",
    "kz-ala-1-san-nvme-h1"
  ]
}
