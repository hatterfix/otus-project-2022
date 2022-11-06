terraform {
  required_providers {
    #Set provider version that will be installed.
    #If use "~> 0.35" will be installed higher ver.
    yandex = "~>0.35"
  }
  required_version = "0.12.19"
}

provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

resource "yandex_kubernetes_cluster" "yc-cluster" {
  name       = "yc-cluster"
  network_id = var.network_id

  master {
    version = "1.23"
    zonal {
      zone      = var.zone
      subnet_id = var.subnet_id
    }
    public_ip = true
  }

  service_account_id      = var.service_account_id
  node_service_account_id = var.service_account_id

  release_channel = "RAPID"
  network_policy_provider = "CALICO"
}

resource "yandex_kubernetes_node_group" "cluster-node" {
  cluster_id = yandex_kubernetes_cluster.yc-cluster.id
  version    = "1.23"
  name = "k8s-node"

  instance_template {
      nat       = true

    resources {
    core_fraction = 5
    cores         = 4
    memory        = 4
    }

    boot_disk {
      type = "network-ssd"
      size = 64
    }

    metadata = {
      ssh-keys = "ubuntu:${file(var.public_key_path)}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 1
    }
  }
}
