resource "azuread_application_registration" "ar_image_push" {
  display_name = "githubactions_push"
}

resource "azuread_service_principal" "sp_image_push" {
  client_id = azuread_application_registration.ar_image_push.client_id
}

resource "azuread_application_federated_identity_credential" "afic_image_push" {
  application_id = azuread_application_registration.ar_image_push.id
  display_name   = "fed_app_push_to_acr"
  description    = "Deployments for my-repo"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:SkrzyniarzPatryk/cloudf6-payment-app:environment:deployment"
}

resource "azurerm_role_assignment" "ra_reader" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPush"
  principal_id         = azuread_service_principal.sp_image_push.object_id
  principal_type       = "ServicePrincipal"
}

#################
# Outputs
#################
output "service_principal_client_id" {
  value = azuread_service_principal.sp_image_push.client_id
}