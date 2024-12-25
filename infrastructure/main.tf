# Resource group
resource "azurerm_resource_group" "default" {
  name     = "${var.prefix}-resources"
  location = var.location
}

# Virtual Network
resource "azurerm_virtual_network" "default" {
  name                = "${var.prefix}-VN"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  address_space       = ["10.0.0.0/28"]
}

# VN subnet
resource "azurerm_subnet" "default" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = azurerm_resource_group.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.0.0.0/28"]
}

# Network interface
resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-main-NIC"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.main.id
  }
}

resource "azurerm_network_interface" "runner" {
  name                = "${var.prefix}-runner-NIC"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.default.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.runner.id
  }
}

# Instances
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.prefix}-main-VM"
  location              = azurerm_resource_group.default.location
  resource_group_name   = azurerm_resource_group.default.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_DS2_v2"
  admin_username        = var.admin_user

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.ssh_pub_key_file)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "runner" {
  name                  = "${var.prefix}-runner-VM"
  location              = azurerm_resource_group.default.location
  resource_group_name   = azurerm_resource_group.default.name
  network_interface_ids = [azurerm_network_interface.runner.id]
  size                  = "Standard_A2m_v2"
  # Standard_DC2ds_v2
  admin_username        = var.admin_user

  admin_ssh_key {
    username   = var.admin_user
    public_key = file(var.ssh_pub_key_file)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

# Public Ip-address
resource "azurerm_public_ip" "main" {
  name                    = "${var.prefix}-main-pub-IP"
  location                = azurerm_resource_group.default.location
  resource_group_name     = azurerm_resource_group.default.name
  allocation_method       = "Static"
  # sku                     = "Basic"
  idle_timeout_in_minutes = 4
}

resource "azurerm_public_ip" "runner" {
  name                    = "${var.prefix}-runner-pub-IP"
  location                = azurerm_resource_group.default.location
  resource_group_name     = azurerm_resource_group.default.name
  allocation_method       = "Static"
  # sku                     = "Basic"
  idle_timeout_in_minutes = 4
}

# Network security group
resource "azurerm_network_security_group" "default" {
  name                = "${var.prefix}-nsg"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTPS"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-MT"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "9236"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# associate the nsg with the network subnet
resource "azurerm_subnet_network_security_group_association" "default" {
  subnet_id                 = azurerm_subnet.default.id
  network_security_group_id = azurerm_network_security_group.default.id
}