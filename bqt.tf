provider "google" {
  user_project_override = true
  access_token          = var.access_token
}

resource "google_bigquery_data_transfer_config" "example_cloud_storage" {
  display_name           = "my-demo-tf"
  project                = "modular-scout-345114"
  destination_dataset_id = "testDS"
  schedule               = "first sunday of quarter 00:00"
  data_source_id         = "google_cloud_storage"
  params = {
    data_path_template =   "gs://my-bucket-df/SampleCSVFile_2kb.csv"    
    destination_table_name_template = "testTable"
    file_format = "CSV"
  }

  service_account_name   = "cloud-composer-sa-id@modular-scout-345114.iam.gserviceaccount.com"
}
