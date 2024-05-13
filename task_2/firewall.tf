resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.army-task2.self_link

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}



