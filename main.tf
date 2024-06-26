data "openstack_images_image_v2" "image_data" {
  most_recent = true
  properties = {
    os_distro  = "centos-stream"
    os_version = "9"
  }
}

data "openstack_networking_network_v2" "external_network" {
  name = "FloatingIP Net"
}

resource "openstack_networking_network_v2" "network" {
  name           = "network"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "subnet" {
  name        = "subnet"
  network_id  = openstack_networking_network_v2.network.id
  cidr        = "192.168.10.0/24"
  ip_version  = 4
  enable_dhcp = true
  depends_on  = [openstack_networking_network_v2.network]
}

resource "openstack_networking_router_v2" "router" {
  name                = "router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.external_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id  = openstack_networking_router_v2.router.id
  subnet_id  = openstack_networking_subnet_v2.subnet.id
  depends_on = [openstack_networking_router_v2.router]
}

resource "openstack_compute_secgroup_v2" "security_group" {
  name        = "sg1"
  description = "open ssh and http"
  dynamic "rule" {
    for_each = ["22", "80"]
    content {
      from_port   = rule.value
      to_port     = rule.value
      ip_protocol = "tcp"
      cidr        = "0.0.0.0/0"
    }
  }
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }
}

resource "openstack_compute_instance_v2" "ansible_control_node" {
  name            = "control_node"
  flavor_name     = var.flavor_name[1]
  security_groups = [openstack_compute_secgroup_v2.security_group.id]
  config_drive    = true
  depends_on      = [openstack_networking_subnet_v2.subnet]
  user_data       = templatefile("${path.module}/cloud-config/control.tftpl", { secret = var.secret, cloudsb64 = var.cloudsb64 })
  tags            = ["control"]

  network {
    uuid = openstack_networking_network_v2.network.id
  }

  block_device {
    source_type           = "image"
    uuid                  = data.openstack_images_image_v2.image_data.id
    destination_type      = "volume"
    volume_type           = var.volume_type[0]
    volume_size           = 10
    delete_on_termination = true
  }
}

resource "openstack_compute_instance_v2" "alb_node" {
  name            = "alb_node"
  flavor_name     = var.flavor_name[0]
  security_groups = [openstack_compute_secgroup_v2.security_group.id]
  config_drive    = true
  depends_on      = [openstack_networking_subnet_v2.subnet]
  user_data       = templatefile("${path.module}/cloud-config/managed.tftpl", { password_hash = var.managed_password_hash })
  tags            = ["alb"]

  network {
    uuid = openstack_networking_network_v2.network.id
  }

  block_device {
    source_type           = "image"
    uuid                  = data.openstack_images_image_v2.image_data.id
    destination_type      = "volume"
    volume_type           = var.volume_type[0]
    volume_size           = 10
    delete_on_termination = true
  }
}

resource "openstack_compute_instance_v2" "webserver_node" {
  count           = 3
  name            = "webserver-${count.index}"
  flavor_name     = var.flavor_name[0]
  security_groups = [openstack_compute_secgroup_v2.security_group.id]
  config_drive    = true
  depends_on      = [openstack_networking_subnet_v2.subnet]
  user_data       = templatefile("${path.module}/cloud-config/managed.tftpl", { password_hash = var.managed_password_hash })
  tags            = ["webserver"]

  network {
    uuid = openstack_networking_network_v2.network.id
  }

  block_device {
    source_type           = "image"
    uuid                  = data.openstack_images_image_v2.image_data.id
    destination_type      = "volume"
    volume_type           = var.volume_type[0]
    volume_size           = 10
    delete_on_termination = true
  }
}

resource "openstack_networking_floatingip_v2" "fip" {
  pool = data.openstack_networking_network_v2.external_network.name
}

resource "openstack_compute_floatingip_associate_v2" "fip_association" {
  floating_ip = openstack_networking_floatingip_v2.fip.address
  instance_id = openstack_compute_instance_v2.alb_node.id
  fixed_ip    = openstack_compute_instance_v2.alb_node.access_ip_v4
}
