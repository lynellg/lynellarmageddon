# Europe's Firewall
resource "google_compute_firewall" "europe-http-allow" {
  name    = "europe-http-allow"
  network = google_compute_network.europe-gaming.self_link
  description = "europe-http-allow"
  direction = "INGRESS"
  priority = "1000"
  source_ranges = ["172.16.1.0/24", "172.16.6.0/24", "192.168.1.0/24"]  

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  }


# Asia's Firewall
resource "google_compute_firewall" "asias-firewall" {
  name    = "asias-firewall"
  network = google_compute_network.asia-gaming.self_link
  description = "asias-firewall"
  direction = "INGRESS"
  priority = "1000"
  source_ranges = ["0.0.0.0/0"]  

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  }


# America's Firewall
resource "google_compute_firewall" "americas-firewall" {
  name    = "americas-firewall"
  network = google_compute_network.americas-gaming.self_link
  description = "americas-firewall"
  direction = "INGRESS"
  priority = "1000"
  source_ranges = ["0.0.0.0/0"]  

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  }
