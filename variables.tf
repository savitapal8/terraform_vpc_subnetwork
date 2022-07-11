variable "access_token" {
  description = "access_token"
  type        = string
  sensitive   = true
}

variable "project_id" {
  description = "project_id"
  type        = string
  default     = "modular-scout-345114"
}

variable "vpc_name" {
  description = "us-dev-appid-syst-demo-vpc"
  type        = string
  default = "us-dev-appid-syst-demo-vpc"
}

variable "subnet_name" {
  description = "us-dev-appid-syst-demo-subnet"
  type        = string
  default = "us-dev-appid-syst-demo-subnet"
}

variable "route_name" {
  description = "us-dev-appid-syst-demo-route"
  type        = string
  default = "us-dev-appid-syst-demo-route"
}