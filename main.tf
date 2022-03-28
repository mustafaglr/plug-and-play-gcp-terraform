resource "google_service_account" "default" {
  account_id   = var.service_account
  display_name = "Service Account"
}

resource "google_compute_instance" "default" {

  name         = var.machine_name
  machine_type = var.machine_type
  zone         = var.machine_zone

  description = var.description
  can_ip_forward = var.can_ip_forward
  desired_status = var.desired_status 
  deletion_protection = var.deletion_protection
  hostname = var.hostname
  guest_accelerator = var.guest_accelerator
  allow_stopping_for_update = var.allow_stopping_for_update
  min_cpu_platform = var.min_cpu_platform
  project = var.project 
  enable_display = var.enable_display
  resource_policies = var.resource_policies

  dynamic "scheduling" {
    for_each = var.scheduling
    content {
      preemptible = scheduling.value.scheduling
      on_host_maintenance = scheduling.value.on_host_maintenance
      automatic_restart = scheduling.value.automatic_restart
      min_node_cpus = scheduling.value.min_node_cpus
      
      dynamic "node_affinities" {
        for_each = scheduling.value.node_affinities
        content {
          key = node_affinities.value.key
          operator = node_affinities.value.operator
          values = node_affinities.value.values
        }
      } 
    }
  }

  dynamic "shielded_instance_config" {
    for_each = var.shielded_instance_config
    content {
      enable_secure_boot = shielded_instance_config.value.enable_secure_boot
      enable_vtpm = shielded_instance_config.value.enable_vtpm
      enable_integrity_monitoring = shielded_instance_config.value.enable_integrity_monitoring
    }
  }

  dynamic "reservation_affinity" {
    for_each = var.reservation_affinity
    content {
      type = reservation_affinity.value.type
      dynamic "specific_reservation" {
        for_each = reservation_affinity.value.specific_reservation
        content {
          key = specific_reservation.value.key
          values = specific_reservation.value.values
        }
      }
    }
  }

  dynamic "confidential_instance_config" {
    for_each = var.confidential_instance_config
    content {
      enable_confidential_compute = confidential_instance_config.value.enable_confidential_compute
    }
  }

  dynamic "advanced_machine_features" {
    for_each = var.advanced_machine_features
    content {
      enable_nested_virtualization = advanced_machine_features.value.enable_nested_virtualization
      threads_per_core = advanced_machine_features.value.threads_per_core
    }
  }

  tags = var.tags["network"]
  labels = var.labels["network"]

  boot_disk {
    initialize_params {
      image = var.boot_disk_machine_image
      type  = var.boot_disk_type
    }
    auto_delete             = var.boot_disk_auto_delete
    device_name             = var.boot_disk_device_name
    mode                    = var.boot_disk_mode
    disk_encryption_key_raw = var.is_boot_disk_disk_encryption_key_raw ? var.boot_disk_disk_encryption_key_raw : null
    kms_key_self_link       = var.is_boot_disk_kms_key_self_link ? var.boot_disk_kms_key_self_link : null
  }

  // Local SSD disk
  scratch_disk {
    interface = var.scratch_disk_interface
  }

  network_interface {
    network = var.network_interface_network
    subnetwork = var.network_interface_subnetwork
    subnetwork_project = var.network_interface_subnetwork_project
    network_ip = var.network_interface_network_ip
    nic_type = var.network_interface_nic_type
    stack_type = var.network_interface_stack_type
    queue_count = var.network_interface_queue_count

    dynamic "ipv6_access_config" {
      for_each = var.ipv6_access_config
      content {
        public_ptr_domain_name = ipv6_access_config.value.public_ptr_domain_name
        network_tier = ipv6_access_config.value.network_tier
      }
    }

    dynamic "alias_ip_range" {
      for_each = var.alias_ip_range
      content {
        ip_cidr_range = alias_ip_range.value.ip_cidr_range
        subnetwork_range_name = alias_ip_range.value.subnetwork_range_name
      }
    }


    dynamic "access_config" {
      for_each = var.access_config
      content {
        nat_ip = access_config.value.nat_ip
        public_ptr_domain_name = access_config.value.public_ptr_domain_name
        network_tier = access_config.value.network_tier
      }
    }
  }

  metadata = var.metadata["meta"]

  lifecycle {
    ignore_changes = [attached_disk]
  }

  service_account {
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_disk" "default" {
  for_each = var.compute_disk

  name                      = each.value["compute_disk_name"]
  type                      = each.value["compute_disk_type"]
  zone                      = each.value["compute_disk_zone"]
  image                     = each.value["compute_disk_image"]
  labels                    = each.value["compute_disk_labels"]
  physical_block_size_bytes = each.value["compute_disk_physical_block_size_bytes"]
  description               = each.value["compute_disk_description"]
  size                      = each.value["compute_disk_size"]
  provisioned_iops          = each.value["compute_disk_provisioned_iops"]
  project                   = each.value["compute_disk_project"]
}

resource "google_compute_attached_disk" "default" {
  count = length(var.attached_disk)

  disk     = google_compute_disk.default["compute_disk_default_${count.index+1}"].id
  instance = google_compute_instance.default.id

  device_name = var.attached_disk["attached_disk_default_${count.index+1}"]["attached_disk_device_name"]
  mode        = var.attached_disk["attached_disk_default_${count.index+1}"]["attached_disk_mode"]
}


