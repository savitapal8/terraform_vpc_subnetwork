resource "google_compute_subnetwork" "subnet-with-logging" {
  name          = "log-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.vpc_network.id

  
  
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = null
    metadata             = "EXCLUDE_ALL_METADATA"
  } 
}
