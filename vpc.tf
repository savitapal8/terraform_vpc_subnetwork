provider "google" {
  user_project_override = true
  access_token          = var.access_token
}

resource "google_compute_network" "vpc_network" {
  project                 = "my-project-name"
  name                    = "vpc-network"
  mtu                     = 1460
}
