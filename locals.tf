locals {
  # Define VMs and their configurations in one place
  vms = {
    # Set 1 (domain_1/network_1)
    NUBRXFS = {
      network_key   = "network_1"
      ip_address    = "20.20.20.213"
      domain_key    = "domain_1"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 }
      ]
      
    },

    NUBRXSCCMSUP = {
      network_key   = "network_1"
      ip_address    = "20.20.20.210"
      domain_key    = "domain_1"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 }
      ]
     
    },

    NUBRXSCOM = {
      network_key   = "network_1"
      ip_address    = "20.20.20.214"
      domain_key    = "domain_1"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 }
      ]
      
    },

    NUBRXSQL = {
      network_key   = "network_1"
      ip_address    = "20.20.20.215"
      domain_key    = "domain_1"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 },
        { label = "disk2", unit_number = 2, size = 100 },
        { label = "disk3", unit_number = 3, size = 50 }
      ]
      
    },

    NUBRXSCCM = {
      network_key   = "network_1"
      ip_address    = "20.20.20.216"
      domain_key    = "domain_1"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 },
        { label = "disk2", unit_number = 2, size = 300 },
        { label = "disk3", unit_number = 3, size = 100 },
        { label = "disk4", unit_number = 4, size = 50 }
      ]
     
    },

    # Set 2 (domain_2/network_2) - DR copies
    NUCTAFS = {
      network_key   = "network_2"
      ip_address    = "30.30.30.213"
      domain_key    = "domain_2"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 }
      ]
     
    },

    NUCTASCCMSUP = {
      network_key   = "network_2"
      ip_address    = "30.30.30.210"
      domain_key    = "domain_2"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 }
      ]
     
    },

    NUCTASCOM = {
      network_key   = "network_2"
      ip_address    = "30.30.30.214"
      domain_key    = "domain_2"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 }
      ]
      
    },

    NUCTASQL = {
      network_key   = "network_2"
      ip_address    = "30.30.30.215"
      domain_key    = "domain_2"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 },
        { label = "disk2", unit_number = 2, size = 100 },
        { label = "disk3", unit_number = 3, size = 50 }
      ]
      playbook_name = "playbook_nubrxsql.yml"
    },

    NUCTASCCM = {
      network_key   = "network_2"
      ip_address    = "30.30.30.216"
      domain_key    = "domain_2"
      extra_disks   = [
        { label = "disk1", unit_number = 1, size = 300 },
        { label = "disk2", unit_number = 2, size = 300 },
        { label = "disk3", unit_number = 3, size = 100 },
        { label = "disk4", unit_number = 4, size = 50 }
      ]
      
    }
  }

  # Domains map for selecting the domain and datastore based on domain_key
  domains = {
    domain_1 = {
      domain       = var.vm_domain_1
      datastore_id = data.vsphere_datastore.ds1.id
    },
    domain_2 = {
      domain       = var.vm_domain_2
      datastore_id = data.vsphere_datastore.ds2.id
    }
  }
}
