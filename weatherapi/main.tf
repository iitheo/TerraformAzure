# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

  required_version = ">= 1.1.0"
}

terraform {
  backend "azurerm" {
    resource_group_name = "tf_rg_blobstore"
    storage_account_name = "tfstorageiitheo1"
    container_name = "tfstate"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

variable "imagebuild" {
  type = string
  description = "Latest Image Build"
}

resource "azurerm_resource_group" "tf_test" {
  name     = "tfmainrg"
  location = "ukwest"
}

resource "azurerm_container_group" "tfcg_test" {
  name     = "weatherapi"
  location = azurerm_resource_group.tf_test.location
  resource_group_name = azurerm_resource_group.tf_test.name

  ip_address_type = "public"
  dns_name_label = "iitheo1wa"
  os_type = "linux"

  container {
      name = "weatherapi"
      image = "iitheo1/weatherapi:${var.imagebuild}"
      cpu = "1"
      memory = "1"

      ports{
          port = 80
          protocol = "TCP"
      }
  }
}
