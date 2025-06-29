output "public_ip_address" {
  description = "The public IP address of the load balancer"
  value       = azurerm_public_ip.lb_public_ip.ip_address
}
