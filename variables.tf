variable "vsphere_user" {
  type        = string
  description = "Username to connect to vSphere."
}

variable "vsphere_password" {
  type        = string
  sensitive   = true
  description = "Password to connect to vSphere."
}

variable "vsphere_server" {
  type        = string
  description = "vSphere server (e.g. vcenter.example.com)."
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "Local administrator password for the created VMs."
}

variable "domainuser" {
  type        = string
  description = "Domain user (e.g. DOMAIN\\username) with permissions to join machines."
}

variable "domainpass" {
  type        = string
  sensitive   = true
  description = "Password for the domain user."
}

variable "vm_domain_1" {
  type        = string
  description = "The first domain to join for set 1 VMs."
}

variable "vm_domain_2" {
  type        = string
  description = "The second domain to join for set 2 VMs."
}

variable "networks" {
  type = map(object({
    network_name    = string
    gateway         = string
    domain          = string
    dns_server_list = list(string)
  }))
  description = "A map of networks to their configurations."

  default = {
    "network_1" = {
      network_name    = "m05"                               #VMware Netwrok
      gateway         = "20.20.20.1"
      domain          = "m004.lab.com"                      #Domain
      dns_server_list = ["20.20.20.200", "20.20.20.1"]      #Dns
    },
    "network_2" = {
      network_name    = "n05"
      gateway         = "30.30.30.1"
      domain          = "n004.lab.com"
      dns_server_list = ["30.30.30.200", "30.30.30.1"]
    }
  }
}
