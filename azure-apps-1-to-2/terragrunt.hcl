include "root" {
  path = find_in_parent_folders()
}


dependencies {
  paths = ["../azure-site-1","../azure-workload-1","../azure-workload-2"]
}

dependency "workloads1" {
  config_path = "../azure-workload-1"
}
dependency "workloads2" {
  config_path = "../azure-workload-2"
}

inputs = {
    workload1_ip = dependency.workloads1.outputs.workload_private_ip
    workload2_ip = dependency.workloads2.outputs.workload_private_ip
}
