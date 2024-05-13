# America's Peering Network
resource "google_compute_network_peering" "americas-peer" {
  name         = "americas-peer"
  network      = google_compute_network.americas-gaming.self_link
  peer_network = google_compute_network.europe-gaming.self_link
}

# Europe's Peering Network
resource "google_compute_network_peering" "europes-peer" {
  name         = "europes-peer"
  network      = google_compute_network.europe-gaming.self_link
  peer_network = google_compute_network.americas-gaming.self_link
}
