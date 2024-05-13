output "army_output" {
  value = <<EOF
  Public IP = http://${google_compute_instance.army-task-2.network_interface.0.access_config[0].nat_ip}
  VPC Network = ${google_compute_network.army-task2.name}
  Subnet = 10.128.0.0/20
  Internal IP = ${google_compute_instance.army-task-2.network_interface.0.network_ip}
  EOF
}