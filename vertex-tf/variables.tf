variable "project_id" {
    type = string
}
variable "access_token" {
    type = string
    sensitive = true
}
variable "keyring_name" {
    type = string
}
variable "key_name" {
    type = string
}
variable "featurestore_name" {
    type = string
}
variable "entitytype_name" {
    type = string
}
variable "notebooks_env_name" {
    type = string
}