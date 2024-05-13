terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "5.27.0"
    }
  }
}

provider "google" {
  # Configuration options

  credentials = "subtle-hydra-419618-740ba6214d38.json"
  project = "subtle-hydra-419618"
  region = "us-central1"
  zone = "us-central1-a"
  

}
