

resource "google_project_iam_member" "permissions" {
  project = "modular-scout-345114"
  role   = "roles/iam.serviceAccountShortTermTokenMinter"
  member = "serviceAccount:service-1111111-compute@developer.gserviceaccount.com"
}

resource "google_bigquery_data_transfer_config" "wf-us-prod-bqt-fghi-bqt_app01" {
  depends_on = [google_project_iam_member.permissions]

  display_name           = "wf-us-prod-bqt-fghi-bqt_app01"
  location               = "US"
  data_source_id         = "scheduled_query"
  schedule               = "first sunday of quarter 00:00"
  destination_dataset_id = google_bigquery_dataset.wf_us_dev_bq_fghi_dataset1.dataset_id
  params = {
    destination_table_name_template = "my_table"
    write_disposition               = "WRITE_APPEND"
    query                           = "SELECT name FROM tabl WHERE x = 'y'"
  }
service_account_name = "serviceAccount:1234-compute@developer.gserviceaccount.com"
}

resource "google_bigquery_dataset" "wf_us_dev_bq_fghi_dataset1" {
  depends_on = [google_project_iam_member.permissions]

  dataset_id    = "wf_us_dev_bq_fghi_dataset1"
  friendly_name = "foo"
  description   = "bar"
  location      = "US"
}
