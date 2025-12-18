#!/bin/bash

# script commands
COMMAND=$1
if [[ -z "$COMMAND" ]]; then
  echo "Usage: $0 <apply|destroy>"
  exit 1
fi

# targets
targets=(
  "-target=azurerm_container_registry.acr"
  "-target=azurerm_role_assignment.ra_reader"
  "-target=azurerm_resource_group.rg"
  "-target=azurerm_virtual_network.vnet"
  "-target=azurerm_subnet.db_sn"
  "-target=azurerm_private_dns_zone.private_dns"
  "-target=azurerm_private_dns_zone_virtual_network_link.private_dns_link"
  "-target=azurerm_postgresql_flexible_server.psql_server"
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