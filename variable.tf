variable "project" {
  type    = string
  default = "default"
}
variable "region" {
  type    = string
  default = "default"
}

variable "tags" {
  default = {
    network = [
      "foo",
      "bar"
    ]

    anothernetwork = [
      "anotherfoo",
      "anotherbar"
    ]
  }
}


variable "labels" {
  default = {
    network = {
      "foo"= "bar"
    }

    anothernetwork = {
      "foo"= "bar"
    }
  }
}

variable "backend_bucket" {
  type    = string
  default = "tf-state"
}

variable "backend_prefix" {
  type    = string
  default = "terraform/state"
}

variable "service_account" {
  type    = string
  default = "default-prod"
}

variable "machine_name" {
  type    = string
  default = "name"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "machine_zone" {
  type    = string
  default = "europe-west3-a"
}

variable "machine_image" {
  type    = string
  default = "debian-cloud/debian-9"
}

variable "metadata" {
  default = {
    meta = {
      foo = "foo"
      bar = "bar"
    }

    anothermeta = {
      anothermetafoo     = "foobar"
      anothermetabar     = "barfoo"
      startup-script-url = "gs://<bucket>/path/to/file"
    }
  }
}

variable "is_boot_disk_extra" {
  type    = bool
  default = false
}

variable "is_compute_instance" {
  type    = bool
  default = true
}

variable "is_attached_disk" {
  type    = bool
  default = false
}

variable "attached_disk" {
  type = map(object({
    attached_disk_device_name = string
    attached_disk_mode        = string
  }))

  default = {
    "attached_disk_default_1" = {
      attached_disk_device_name = "default"
      attached_disk_mode        = "READ_WRITE"
    }
  }

}

variable "is_compute_disk" {
  type    = bool
  default = false
}

variable "compute_disk" {
  type = map(object({
    compute_disk_name                      = string
    compute_disk_type                      = string
    compute_disk_zone                      = string
    compute_disk_image                     = string
    compute_disk_labels                    = any
    compute_disk_physical_block_size_bytes = number
    compute_disk_description               = string
    compute_disk_size                      = number
    compute_disk_physical_block_size_bytes = number
    compute_disk_provisioned_iops          = number
    compute_disk_project                   = string
  }))

  default = {
    "compute_disk_default_1" = {
      compute_disk_name  = "default"
      compute_disk_type  = "pd-ssd"
      compute_disk_zone  = "europe-west3-a"
      compute_disk_image = "debian-9-stretch-v20200805"
      compute_disk_labels = {
        label = "value"
      }
      compute_disk_physical_block_size_bytes = null
      compute_disk_description               = ""
      compute_disk_size                      = null
      compute_disk_physical_block_size_bytes = null
      compute_disk_provisioned_iops          = null
      compute_disk_project                   = ""
    }
    
  }

}

variable "boot_disk_machine_image" {
  type    = string
  default = "debian-cloud/debian-9"
}

variable "boot_disk_type" {
  type    = string
  default = null
}

variable "boot_disk_auto_delete" {
  type    = bool
  default = true
}

variable "boot_disk_device_name" {
  type    = string
  default = null
}

variable "boot_disk_mode" {
  type    = string
  default = null
}

variable "is_boot_disk_disk_encryption_key_raw" {
  type    = bool
  default = false
}

variable "boot_disk_disk_encryption_key_raw" {
  type    = string
  default = ""
}

variable "is_boot_disk_kms_key_self_link" {
  type    = bool
  default = false
}

variable "boot_disk_kms_key_self_link" {
  type    = string
  default = ""
}

variable "scratch_disk_interface" {
  type    = string
  default = "SCSI"
}

variable "network_interface_network" {
  type    = string
  default = null
}
variable "network_interface_subnetwork" {
  type    = string
  default = null
}
variable "network_interface_subnetwork_project" {
  type    = string
  default = null
}
variable "network_interface_network_ip" {
  type    = string
  default = null
}
variable "network_interface_nic_type" {
  type    = string
  default = null
}
variable "network_interface_stack_type" {
  type    = string
  default = null
}
variable "network_interface_queue_count" {
  type    = string
  default = null
}

variable "alias_ip_range" {
  type = map(object({
    ip_cidr_range     = string
    subnetwork_range_name        = string
  }))

  validation {
    condition = (
        length(var.alias_ip_range) == 1 || length(var.alias_ip_range) == 0
    )
    error_message = "Alias ip range list can not have more than 2 objects!"
  }

  default = {}
}

variable "ipv6_access_config" {
  type = map(object({
    public_ptr_domain_name     = string
    network_tier        = string
  }))

  validation {
    condition = (
        length(var.ipv6_access_config) == 1 || length(var.ipv6_access_config) == 0
    )
    error_message = "İpv6 access config list can not have more than 2 objects!"
  }

  default = {}
}

variable "access_config" {
  type = map(object({
    nat_ip = string
    public_ptr_domain_name = string
    network_tier = string
  }))

  validation {
    condition = (
        length(var.access_config) == 1 || length(var.access_config) == 0
    )
    error_message = "Access config list can not have more than 2 objects!"
  }

  default = {}
}


variable "allow_stopping_for_update" {
  type    = bool
  default = true
}
variable "description" {
   type = string
   default = null
}
variable "can_ip_forward" {
   type = bool
   default = null
}
variable "desired_status" {
   type = string
   default = null
}
variable "deletion_protection" {
   type = string
   default = null
}
variable "hostname" {
   type = string
   default = null
}
variable "guest_accelerator" {
   type = list
   default = null
}
variable "min_cpu_platform" {
   type = string
   default = null
}

variable "enable_display" {
   type = string
   default = null
}
variable "resource_policies" {
   type = list
   default = null
}
variable "network_performance_config" {
   type = string
   default = null
}

variable "scheduling" {
  type = map(object({
    preemptible = string
    on_host_maintenance = string
    automatic_restart = string
    min_node_cpus = string
    provisioning_model = string
    node_affinities = map(object({
      key = string
      operator = string
      values = string
    })) 
  }))

  validation {
    condition = (
        length(var.scheduling) == 1 || length(var.scheduling) == 0
    )
    error_message = "Scheduling list can not have more than 2 objects!"
  }

  default = {}
}

variable "shielded_instance_config" {
  type = map(object({
    enable_secure_boot = string
    enable_vtpm = string
    enable_integrity_monitoring = string
  }))

  validation {
    condition = (
        length(var.shielded_instance_config) == 1 || length(var.shielded_instance_config) == 0
    )
    error_message = "Shielded instance config can not have more than 2 objects!"
  }

  default = {}
}

variable "confidential_instance_config" {
  type = map(object({
    enable_confidential_compute     = string
  }))

  validation {
    condition = (
        length(var.confidential_instance_config) == 1 || length(var.confidential_instance_config) == 0
    )
    error_message = "Confidential instance config list can not have more than 2 objects!"
  }

  default = {}
}

variable "advanced_machine_features" {
  type = map(object({
    enable_nested_virtualization     = string
    threads_per_core        = string
  }))

  validation {
    condition = (
        length(var.advanced_machine_features) == 1 || length(var.advanced_machine_features) == 0
    )
    error_message = "Advanced machine features list can not have more than 2 objects!"
  }

  default = {}
}

variable "reservation_affinity" {
  type = map(object({
    type = string
    specific_reservation = map(object({
      key = string
      values = string
    })) 
  }))

  validation {
    condition = (
        length(var.reservation_affinity) == 1 || length(var.reservation_affinity) == 0
    )
    error_message = "Reservation affinity list can not have more than 2 objects!"
  }

  default = {}
}