include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../base-azure-network-2"]
}

dependency "infrastructure" {
  config_path = "../base-azure-network-2"
}

inputs = {
    resourceGroup = dependency.infrastructure.outputs.resourceGroup
    hubVnetName   = dependency.infrastructure.outputs.hubVnetName
}

