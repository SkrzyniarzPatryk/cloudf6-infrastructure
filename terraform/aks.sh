#!/bin/bash

# script commands
COMMAND=$1
if [[ -z "$COMMAND" ]]; then
  echo "Usage: $0 <apply|destroy>"
  exit 1
fi

# targets
targets=(
  "-target=module.aks_and_appgw"
  "-target=azurerm_virtual_network.vnet"
  "-target=azurerm_subnet.appgw_sn"
  "-target=azurerm_subnet.aks_sn"
  "-target=azurerm_subnet.db_sn"
  "-target=module.postgres_flexible_server"
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