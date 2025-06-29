provider "azurerm" {
  features {}
}

# 创建资源组
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# 创建虚拟网络
resource "azurerm_virtual_network" "vnet" {
  name                = "myVnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
}

# 创建子网
resource "azurerm_subnet" "subnet" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 创建公共 IP（负载均衡器用）
resource "azurerm_public_ip" "public_ip" {
  name                = "myPublicIP"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# 创建负载均衡器
resource "azurerm_lb" "lb" {
  name                = "myLoadBalancer"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

# 创建探测器（检查后端 VM 健康状态）
resource "azurerm_lb_probe" "probe" {
  name                = "httpProbe"
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.lb.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 5
  number_of_probes    = 2
}

# 创建负载均衡规则（让 LB 把请求转发到 VM）
resource "azurerm_lb_rule" "lbrule" {
  name                           = "httpRule"
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.probe.id
}

# 🧱 后续步骤我们将创建多个 VM、NIC、NSG 并连接 LB 后端池
