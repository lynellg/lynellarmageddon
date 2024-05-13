resource "google_compute_vpn_gateway" "asia_gateway" {
  name    = "asia-gateway"
  network = "asia-gaming"
  region = "asia-east1"
  depends_on = [ google_compute_subnetwork.asia-gaming-subnet ]
}

resource "google_compute_address" "asia_static_ip" {
  name = "asia-static-ip"
  region = "asia-east1"
}

resource "google_compute_forwarding_rule" "asia_fr_esp" {
  name        = "asia-fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.asia_static_ip.address
  target      = google_compute_vpn_gateway.asia_gateway.self_link
  region = "asia-east1"
}

resource "google_compute_forwarding_rule" "asia_fr_udp500" {
  name        = "asia-fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.asia_static_ip.address
  target      = google_compute_vpn_gateway.asia_gateway.self_link
  region = "asia-east1"

}

resource "google_compute_forwarding_rule" "asia_fr_udp4500" {
  name        = "asia-fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.asia_static_ip.address
  target      = google_compute_vpn_gateway.asia_gateway.self_link
  region = "asia-east1"

}

resource "google_compute_vpn_tunnel" "asias_tunnel" {
  name          = "asias-tunnel"
  peer_ip       = google_compute_address.europe_static_ip.address
  shared_secret = sensitive("a secret message")
  ike_version = 2
  local_traffic_selector = ["192.168.1.0/24"]
  remote_traffic_selector = ["10.0.0.0/24"]


  target_vpn_gateway = google_compute_vpn_gateway.asia_gateway.self_link

  depends_on = [
    google_compute_forwarding_rule.asia_fr_esp,
    google_compute_forwarding_rule.asia_fr_udp500,
    google_compute_forwarding_rule.asia_fr_udp4500,
  ]
}

resource "google_compute_route" "asias_route" {
  name       = "asias-route"
  network    = "asia-gaming"
  dest_range = "10.0.0.0/24"
  priority   = 1000
  depends_on = [ google_compute_vpn_tunnel.asias_tunnel ]

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.asias_tunnel.id
}