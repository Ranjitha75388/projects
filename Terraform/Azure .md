# Terraform in Azure


### STEP 1: Install Required Tools
1. Install Terraform on ubuntu

- Check Architecture
```
uname -m
```   
[Download](https://developer.hashicorp.com/terraform/downloads)

2.Installation
- Unzip the Terraform file
```
unzip terraform_*_linux_amd64.zip
```
3.Move the Terraform binary to a system directory

- Move it to /usr/local/bin (which is in your system’s PATH):
```
sudo mv terraform /usr/local/bin/
```
- Give it permission to run:
```
sudo chmod +x /usr/local/bin/terraform
```
4. Verify the installation
```
terraform -version
```
![image](https://github.com/user-attachments/assets/7e13c99e-c0c4-43b4-90b4-80aa5e99b4e0)

### STEP 2:log into Azure CLI:
```
az login
```
### STEP 3 :Create a folder for Terraform project:
```
mkdir terraform
cd terraform
```
### STEP 4:Create Resource Group
```
nano resourse-group.tf
```
```
provider "azurerm" {
  features {}
  subscription_id = "218e4dbc-8f7c-4433-89b0-196356564251"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "East US"
}
```
### STEP 5:Deploy with Terraform
```
terraform init
terraform plan
terraform apply
```
![image](https://github.com/user-attachments/assets/48125822-f6d2-4601-97dd-3b6de5bc7c17)

![Screenshot from 2025-05-20 16-41-45](https://github.com/user-attachments/assets/9fd16e8b-f76b-4435-8b3e-82056db93327)

![Screenshot from 2025-05-20 16-43-33](https://github.com/user-attachments/assets/a0de5513-7638-49c7-8c29-daf90966d9de)

### STEP 6: Check in Azure portal
![image](https://github.com/user-attachments/assets/f21d2cc5-83aa-4d23-b93b-7e16448a10bb)


### code file

```
provider "azurerm" {
  features {}
  subscription_id = "218e4dbc-8f7c-4433-89b0-196356564251"
}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform"
  location = "East US"
}

# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-terraform"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

# Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "terraform-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "terraform-public-ip"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  name                = "terraform-nic"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# Linux Virtual Machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "terraform-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                = "Standard_B1s"

  os_disk {
    name              = "terraform-osdisk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy-daily"
    sku       = "22_04-daily-lts-gen2"
    version   = "latest"
  }

  computer_name  = "terraformvm"
  admin_username = "ranjitha"

  admin_password = "tharshik@123"  # Change this to a secure password!

  disable_password_authentication = false
}



# Output Public IP
output "public_ip_address" {
  value = azurerm_public_ip.public_ip.ip_address
}





