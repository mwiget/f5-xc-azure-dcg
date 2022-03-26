include "root" {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../base-azure-network-1","../base-azure-network-2"]
}

dependency "network1" {
  config_path = "../base-azure-network-1"
}

dependency "network2" {
  config_path = "../base-azure-network-2"
}

inputs = {
    resourceGroup1 = dependency.network1.outputs.resourceGroup
    hubVnetName1   = dependency.network1.outputs.hubVnetName
    hubVnetId1     = dependency.network1.outputs.hubVnetId

    resourceGroup2 = dependency.network2.outputs.resourceGroup
    hubVnetName2   = dependency.network2.outputs.hubVnetName
    hubVnetId2     = dependency.network2.outputs.hubVnetId
}

