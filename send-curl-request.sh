#!/bin/bash
ip=$(cd azure-workload-1 && terraform output | grep pip | cut -d\" -f2)
cmd="curl -H host:workload.azure1.example.internal 100.64.17.5/txt"
echo "$cmd ..."
ssh -o StrictHostKeyChecking=no azureuser@$ip $cmd
