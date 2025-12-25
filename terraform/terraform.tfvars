location     = "westeurope"
project_name = "javaservices"

common_tags = {
  Owner       = "Patryk"
  Environment = "Development"
  Project     = "JavaServices"
}

agic_enabled = false

aks_node_count                  = 1
aks_vm_size                     = "B2als_v2"
aks_auto_scaling_enabled        = true
aks_min_count                   = 1
aks_max_count                   = 2
aks_temporary_name_for_rotation = "akstemporar"