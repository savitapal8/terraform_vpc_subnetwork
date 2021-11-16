provider "google" {
  user_project_override = true
  access_token          = var.access_token
}

resource "google_compute_network" "vpc_network" {
  project                 = "my-project-name"
  name                    = "vpc-network"
  auto_create_subnetworks = false
  mtu                     = 1460
  delete_default_routes_on_create = true
}