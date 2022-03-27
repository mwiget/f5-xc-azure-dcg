#!/bin/bash
ip=$(cd azure-workload-1 && terraform output | grep pip | cut -d\" -f2)
echo -n "$ip ... "
ssh -o StrictHostKeyChecking=no azureuser@$ip curl -H host:workload.azure1.example.internal 100.64.17.5/txt
