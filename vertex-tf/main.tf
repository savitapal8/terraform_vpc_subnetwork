provider "google-beta" {
  project     = var.project_id
  region      = "us-central1"
  access_token = var.access_token
}

provider "google" {
  project     = var.project_id
  region      = "us-central1"
  access_token = var.access_token
}

data "google_compute_network" "my_network" {
  name = "default"
}

data "google_compute_subnetwork" "my_subnetwork" {
  name   = "default"
  region = "us-central1"
}

#keyring creation
resource "google_kms_key_ring" "keyring" {
  name     = var.keyring_name
  location = "us-central1"
}

#crypto key creation
resource "google_kms_crypto_key" "example-key" {
  name            = var.key_name
  key_ring        = google_kms_key_ring.keyring.id
  rotation_period = "100000s"

  lifecycle {
    prevent_destroy = false
  }
}

#IAM policy for KMS crypto key
data "google_iam_policy" "adminn" {
  binding {
    role = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
    members = [
      "serviceAccount:service-1080178441487@compute-system.iam.gserviceaccount.com",
      "serviceAccount:service-1080178441487@gcp-sa-aiplatform.iam.gserviceaccount.com",
      "serviceAccount:cloud-composer-sa-id@modular-scout-345114.iam.gserviceaccount.com",
    ]
  }
}

resource "google_kms_crypto_key_iam_policy" "crypto_key" {
  crypto_key_id = google_kms_crypto_key.example-key.id
  policy_data = data.google_iam_policy.adminn.policy_data
}

#Notebook Instance
resource "google_notebooks_instance" "instance" {
  depends_on = [
      google_notebooks_runtime.runtime,
      google_kms_crypto_key.example-key
  ]  
  name = "notebooks-instance"
  location = "us-central1-a"
  machine_type = "e2-medium"

  vm_image {
    project      = "deeplearning-platform-release"
    image_family = "tf-latest-cpu"
  }

  instance_owners = ["admin@hashicorptest.com"]
  service_account = "cloud-composer-sa-id@modular-scout-345114.iam.gserviceaccount.com"
 
  kms_key = google_kms_crypto_key.example-key.id
  install_gpu_driver = true
  boot_disk_type = "PD_SSD"
  boot_disk_size_gb = 110

  no_public_ip = true
  no_proxy_access = false

  network = data.google_compute_network.my_network.id
  subnet = data.google_compute_subnetwork.my_subnetwork.id

  labels = {
    k = "val"
  }

  metadata = {
    terraform = "true"
    proxy-mode = "service_account"
  }
}


#Notebook Runtime
resource "google_notebooks_runtime" "runtime" {
  name = "notebooks-runtime"
  location = "us-central1"
  access_config {
    access_type = "SINGLE_USER"
    runtime_owner = "admin@hashicorptest.com"
  }
  virtual_machine {
    virtual_machine_config {
      machine_type = "n1-standard-4"
      data_disk {
        initialize_params {
          disk_size_gb = "100"
          disk_type = "PD_STANDARD"
        }
      }
    }
  }
}

#Notebook instance and runtime IAM policy setup
data "google_iam_policy" "admin" {
  binding {
    role = "roles/viewer"
    members = [
      "user:savitap@google.com",
    ]
  }
}

resource "google_notebooks_instance_iam_policy" "policy" { 
  project = google_notebooks_instance.instance.project
  location = google_notebooks_instance.instance.location
  instance_name = google_notebooks_instance.instance.name
  policy_data = data.google_iam_policy.admin.policy_data
}

resource "google_notebooks_runtime_iam_policy" "policy" { 
  project = google_notebooks_runtime.runtime.project
  location = google_notebooks_runtime.runtime.location
  runtime_name = google_notebooks_runtime.runtime.name
  policy_data = data.google_iam_policy.admin.policy_data
}

#Vertex AI dataset
resource "google_vertex_ai_dataset" "dataset" {
  depends_on = [
      google_kms_crypto_key.example-key,
      google_kms_crypto_key_iam_policy.crypto_key
  ]  
  display_name          = "terraform"
  metadata_schema_uri   = "gs://google-cloud-aiplatform/schema/dataset/metadata/image_1.0.0.yaml"
  region                = "us-central1"
  encryption_spec{
      kms_key_name = google_kms_crypto_key.example-key.id
  }
}

#Vertex AI Featurestore
resource "google_vertex_ai_featurestore" "featurestore" {
  provider = google-beta
  name     = var.featurestore_name
  labels = {
    foo = "bar"
  }
  region   = "us-central1"
  online_serving_config {
    fixed_node_count = 2
  }
}

#Vertex AI Featurestore Entitytype
resource "google_vertex_ai_featurestore_entitytype" "entity" {
  provider = google-beta
  name     = var.entitytype_name
  labels = {
    foo = "bar"
  }
  featurestore = google_vertex_ai_featurestore.featurestore.id
  monitoring_config {
    snapshot_analysis {
      disabled = false
      monitoring_interval = "86400s"
    }
  }
}

#Google Notebooks Env
resource "google_notebooks_environment" "environment" {
  name = var.notebooks_env_name
  location = "us-central1-a"  
  container_image {
    repository = "gcr.io/deeplearning-platform-release/base-cpu"
  } 
}