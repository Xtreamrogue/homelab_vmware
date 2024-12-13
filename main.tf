provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Lab"
}

data "vsphere_datastore" "ds1" {
  name          = "nvme1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "ds2" {
  name          = "nvme2"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "home"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "all" {
  for_each = {
    for k, v in var.networks : k => v.network_name
  }
  name          = each.value
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = "Win2022-Template-Base"
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vms" {
  for_each = local.vms

  name             = each.key
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = local.domains[each.value.domain_key].datastore_id

  num_cpus   = 2
  memory     = 4096
  guest_id   = data.vsphere_virtual_machine.template.guest_id
  firmware   = "efi"
  scsi_type  = data.vsphere_virtual_machine.template.scsi_type

  network_interface {
    network_id   = data.vsphere_network.all[each.value.network_key].id
    adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
  }

  # Base disk from template
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  # Additional disks from locals
  dynamic "disk" {
    for_each = each.value.extra_disks
    content {
      label            = disk.value.label
      unit_number      = disk.value.unit_number
      size             = disk.value.size
      thin_provisioned = true
    }
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id

    customize {
      windows_options {
        computer_name         = each.key
        admin_password        = var.vm_admin_password
        join_domain           = local.domains[each.value.domain_key].domain
        domain_admin_user     = var.domainuser
        domain_admin_password = var.domainpass
      }

      network_interface {
        ipv4_address    = each.value.ip_address
        ipv4_netmask    = 24
        dns_server_list = var.networks[each.value.network_key].dns_server_list
      }

      ipv4_gateway = var.networks[each.value.network_key].gateway
    }
  }

  provisioner "local-exec" {
    command = <<EOT
      sleep 30
      ansible-playbook  -i /home/xtream/gptfinal/ansible/inventory /home/xtream/gptfinal/ansible/site.yml  \
        --extra-vars "ansible_user=Administrator ansible_password=${var.vm_admin_password} ansible_connection=winrm ansible_winrm_server_cert_validation=ignore ansible_port=5985" -vvv
    EOT
  }
}
