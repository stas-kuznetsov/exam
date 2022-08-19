
resource "azurerm_resource_group" "example" {
  name = "Exam"
  location = "Norway East"
}

resource "azurerm_virtual_network" "example" {
  name = "project-vnet"
  address_space = ["10.1.0.0/16"]
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name = "default"
  resource_group_name = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes = ["10.1.0.0/24"]
}

resource "azurerm_public_ip" "myPublicIPJenkins" {
  name = "myPublicIPJenkins"
  location = "Norway East"
  resource_group_name = "Exam"
  allocation_method = "Dynamic"
}

resource "azurerm_public_ip" "myPublicIPProd" {
  name = "myPublicIPProd"
  location = "Norway East"
  resource_group_name = "Exam"
  allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "ProdNIC" {
  name = "ProdNIC"
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  =  azurerm_public_ip.myPublicIPProd.id
  }
}

resource "azurerm_network_interface" "JenkinsNIC" {
  name = "JenkinsNIC"
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id  =  azurerm_public_ip.myPublicIPJenkins.id
  }
}


resource "azurerm_network_interface" "DTRNIC" {
  name = "DTRNIC"
  location = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_configuration {
    name = "internal"
    subnet_id = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}


resource "azurerm_linux_virtual_machine" "Prod" {
  name = "Prod"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  size = "Standard_DS1_v2"
  admin_username = "stas"
  network_interface_ids = [azurerm_network_interface.ProdNIC.id]
  admin_ssh_key {
    username = "stas"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "DTR" {
  name = "DTR"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  size = "Standard_DS1_v2"
  admin_username = "stas"
  network_interface_ids = [azurerm_network_interface.DTRNIC.id]
  admin_ssh_key {
    username = "stas"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "Jenkins" {
  name = "Jenkins"
  resource_group_name = azurerm_resource_group.example.name
  location = azurerm_resource_group.example.location
  size = "Standard_DS1_v2"
  admin_username = "stas"
  network_interface_ids = [azurerm_network_interface.JenkinsNIC.id]
  admin_ssh_key {
    username = "stas"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }
}

