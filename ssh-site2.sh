#!/bin/bash
rg="$(cd base-azure-network-2 && terraform output | grep resourceGroup\ = | cut -d\" -f2)-site2"
echo -n "$rg ... "
ip=$(az network public-ip list --resource-group $rg | grep ipAddress | cut -d\" -f4)
echo -n "$ip ... "
ssh -o StrictHostKeyChecking=no -i ~/.ves-internal/staging/id_rsa vesop@$ip $@
#ssh centos@$ip
