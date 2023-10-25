output "image" {
  value = data.openstack_images_image_v2.image_data.name
}

output "public_ip" {
  value = openstack_networking_floatingip_v2.instance_fip.address
}

output "flavor" {
  value = openstack_compute_instance_v2.ansible_control_node.flavor_name
}

output "cidr" {
  value = openstack_networking_subnet_v2.subnet.cidr
}
