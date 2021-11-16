module "tfplan-functions" {
    source = "../common-functions/tfplan-functions/tfplan-functions.sentinel"
}

module "tfstate-functions" {
    source = "../common-functions/tfstate-functions/tfstate-functions.sentinel"
}

module "tfconfig-functions" {
    source = "../common-functions/tfconfig-functions/tfconfig-functions.sentinel"
}

module "generic-functions" {
    source = "../common-functions/generic-functions/generic-functions.sentinel"
}

mock "tfplan/v2" {
  module {
    source = "./mocks/mock-tfplan-v2.sentinel"
  }
}

policy "network_gcp_vpc_as_defroute_restrictions" {
    source = "./network_gcp_vpc_as_defroute_restrictions.sentinel"
    enforcement_level = "mandatory"
}

policy "network_gcp_vpc_subnet_logs_restrictions" {
    source = "./network_gcp_vpc_subnet_logs_restrictions"
    enforcement_level = "advisory"
}


