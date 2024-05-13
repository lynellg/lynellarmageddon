resource "google_compute_vpn_gateway" "europe_gateway" {
  name    = "europe-gateway"
  network = "europe-gaming"
  region = "europe-central2"
  depends_on = [ google_compute_subnetwork.europe-gaming-subnet ]
}

resource "google_compute_address" "europe_static_ip" {
  name = "europe-static-ip"
  region = "europe-central2"
}

resource "google_compute_forwarding_rule" "europe_fr_esp" {
  name        = "europe-fr-esp"
  ip_protocol = "ESP"
  ip_address  = google_compute_address.europe_static_ip.address
  target      = google_compute_vpn_gateway.europe_gateway.self_link
  region = "europe-central2"

}

resource "google_compute_forwarding_rule" "europe_fr_udp500" {
  name        = "europe-fr-udp500"
  ip_protocol = "UDP"
  port_range  = "500"
  ip_address  = google_compute_address.europe_static_ip.address
  target      = google_compute_vpn_gateway.europe_gateway.self_link
  region = "europe-central2"
}

resource "google_compute_forwarding_rule" "europe_fr_udp4500" {
  name        = "europe-fr-udp4500"
  ip_protocol = "UDP"
  port_range  = "4500"
  ip_address  = google_compute_address.europe_static_ip.address
  target      = google_compute_vpn_gateway.europe_gateway.self_link
  region = "europe-central2"
}

resource "google_compute_vpn_tunnel" "europes_tunnel" {
  name          = "europes-tunnel"
  peer_ip       = google_compute_address.asia_static_ip.address
  shared_secret = sensitive("a secret message")
  ike_version = 2
  local_traffic_selector = ["10.0.0.0/24"]
  remote_traffic_selector = ["192.168.1.0/24"]

  target_vpn_gateway = google_compute_vpn_gateway.europe_gateway.self_link

  depends_on = [
    google_compute_forwarding_rule.europe_fr_esp,
    google_compute_forwarding_rule.europe_fr_udp500,
    google_compute_forwarding_rule.europe_fr_udp4500,
  ]
}

resource "google_compute_route" "europes_route" {
  name       = "europes-route"
  network    = "europe-gaming"
  dest_range = "192.168.1.0/24"
  priority   = 1000
  depends_on = [ google_compute_vpn_tunnel.europes_tunnel ]

  next_hop_vpn_tunnel = google_compute_vpn_tunnel.europes_tunnel.id
}