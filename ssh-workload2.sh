#!/bin/bash
ip=$(cd azure-workload-2 && terraform output | grep pip | cut -d\" -f2)
echo -n "$ip ... "
ssh -o StrictHostKeyChecking=no azureuser@$ip $@
