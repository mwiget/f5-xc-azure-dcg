output projectPrefix {
  value = var.projectPrefix
}
output azureRegion {
  value = var.azureRegion2
}
output resourceGroup {
  value = azurerm_resource_group.rg2.name
}
output hubVnetName {
  value = azurerm_virtual_network.f5-xc-hub2.name
}
output hubVnetId {
  value = azurerm_virtual_network.f5-xc-hub2.id
}
output workloadSubnet {
  value = azurerm_subnet.workload-spoke2.id
}
