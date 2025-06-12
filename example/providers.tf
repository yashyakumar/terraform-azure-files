terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm",
        version = "=3.0.0"
    }
  }

  }

variable "region" {
    type = string
    description = "Region where our resources are located"
    default = "Central India"
  
}

provider "azurerm" {
   features {}
}