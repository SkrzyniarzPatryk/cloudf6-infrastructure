#!/bin/bash

# script commands
COMMAND=$1
if [[ -z "$COMMAND" ]]; then
  echo "Usage: $0 <apply|destroy>"
  exit 1
fi

# targets
targets=(
  "-target=azurerm_application_gateway.network"
  # "-target=azurerm_container_registry.acr"
  "-target=azurerm_kubernetes_cluster.aks"
  "-target=azurerm_public_ip.appgw_public_ip"
  # "-target=azurerm_resource_group.rg"
  "-target=azurerm_role_assignment.acr_pull_assignment"
  "-target=azurerm_role_assignment.agic_subnet_permission"
  "-target=azurerm_role_assignment.agic_appgw_contributor"
  # "-target=azurerm_role_assignment.ra_reader"
  "-target=azurerm_subnet.aks_sn"
  "-target=azurerm_subnet.default_sn"
  # "-target=azurerm_virtual_network.vnet"
)

# apply / destroy command
if [[ "$COMMAND" == "apply" ]]; then
  echo "Running: terraform apply ${targets[@]}"
  terraform apply "${targets[@]}"
elif [[ "$COMMAND" == "destroy" ]]; then
  echo "Running: terraform destroy ${targets[@]}"
  terraform destroy "${targets[@]}"
else
  echo "Error: Invalid command. Use 'apply' or 'destroy'."
  exit 1
fi