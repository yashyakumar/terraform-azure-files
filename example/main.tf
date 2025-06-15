module "test_instance" {

    source = "../"
    user_assigned_identities = [azurerm_user_assigned_identity.vm_access_identity.id]
  
}

resource "azurerm_storage_account" "test_store" {
  name                     = "test675419667"
  resource_group_name      = module.test_instance.resource_group_name
  location                 = module.test_instance.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "testing"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "mycontainer"
  storage_account_name  = azurerm_storage_account.test_store.name
  container_access_type = "private"
}

# --- Key Part 1: Create a User-Assigned Managed Identity ---
resource "azurerm_user_assigned_identity" "vm_access_identity" {
  name                = "vm-blob-access-identity"
  resource_group_name = module.test_instance.resource_group_name
  location            = module.test_instance.location
}

resource "azurerm_role_assignment" "blob_contributor_role" {
  scope                = azurerm_storage_account.test_store.id# Scope is the storage account
  role_definition_name = "Storage Blob Data Contributor"    # Built-in role
  principal_id         = azurerm_user_assigned_identity.vm_access_identity.principal_id
}