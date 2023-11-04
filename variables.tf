variable "flavor_name" {
  default = [
    "d1.ram1cpu1",
    "d1.ram2cpu1",
    "d1.ram4cpu2",
    "d1.ram8cpu2",
    "d1.ram8cpu4",
  ]
}

variable "volume_type" {
  default = [
    "ceph-ssd",
    "ceph-hdd",
    "ceph-backup",
    "kz-ala-1-san-nvme-h1"
  ]
}

variable "secret" {
  type      = string
  sensitive = true
}

variable "managed_password_hash" {
  type      = string
  sensitive = true
}

variable "cloudsb64" {
  type      = string
  sensitive = true
}
