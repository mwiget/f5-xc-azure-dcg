# DCG between F5XC Azure sites

```
workload1  --- azure-site-1 --- F5XC --- azure-site-2 --- workload2
```

LB setup on azure-site-1 for workload.azure1.example.internal on SLI.
Origin Pool points to workload2.

Terragrunt and Terraform are used to deploy sites, workloads, LB and origin pool.

DCG can be enabled via F5XC UI.

