output projectPrefix {
  value = var.projectPrefix
}
output azureRegion {
  value = var.azureRegion1
}
output resourceGroup {
  value = azurerm_resource_group.rg1.name
}
output hubVnetName {
  value = azurerm_virtual_network.f5-xc-hub1.name
}
output hubVnetId {
  value = azurerm_virtual_network.f5-xc-hub1.id
}
output workloadSubnet {
  value = azurerm_subnet.workload-spoke1.id
}
