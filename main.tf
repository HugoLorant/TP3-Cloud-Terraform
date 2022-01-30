terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
}


// accès SSH aux serveurs
//resource "scaleway_account_ssh_key" "main" {
//    name        = "main"
//    public_key = ""
//}

resource "scaleway_instance_ip" "server_ip_next1" {}
resource "scaleway_instance_ip" "server_ip_next2" {}


resource "scaleway_instance_server" "nextcloud_1" {
  type = "DEV1-S"
  image = "ubuntu_focal"
  name = "Serveur_Web_Nextcloud_1"
  ip_id = scaleway_instance_ip.server_ip_next1.id
  user_data = {
    cloud-init = file("${path.module}/nextcloud_install.yml")
  }
}


resource "null_resource" "config_serv1" {
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install ansible -y",
      ]
      
    connection {
      type = "ssh"
      user = "root"
      private_key = "${file(var.scaleway_private_key_path)}"
      host = scaleway_instance_server.nextcloud_1.public_ip
    }
  }

  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u root -i '${scaleway_instance_server.nextcloud_1.public_ip},' --private-key ${var.scaleway_private_key_path} -e 'pub_key=${var.scaleway_public_key_path}' nextcloud_install.yml"
  }



}

resource "scaleway_instance_server" "nextcloud_2" {
  type = "DEV1-S"
  image = "ubuntu_focal"
  name = "Serveur_Web_Nextcloud_2"
  ip_id = scaleway_instance_ip.server_ip_next2.id
}


/*
resource "scaleway_rdb_instance" "main" {
  name          = "BDD_Nextcloud"
  node_type     = "DB-GP-XS"
  engine        = "MySQL-8"
  is_ha_cluster = true
  user_name     = "adm_nextcloud"
  password      = "Nextcloud123+"

  disable_backup = true
  backup_schedule_frequency = 24 # Tous les jours
  backup_schedule_retention = 7  # Garder une par semaine
}

resource "scaleway_rdb_database" "database" {
 instance_id    = scaleway_rdb_instance.main.id
  name           = "Serveur_BDD"
}

resource "scaleway_rdb_privilege" "database_privilege" {
  instance_id   = scaleway_rdb_instance.main.id
  user_name     = "adm_nextcloud"
  database_name = "Serveur_BDD"
  permission    = "all"
}
*/
resource "scaleway_object_bucket" "bucket-data" {
  name = "stockage-nextcloud-HLVH"
  acl  = "private"
}

resource "scaleway_lb_ip" "ip_loadbalancer" {
}

resource "scaleway_lb" "loadbalancer" {
  ip_id  = scaleway_lb_ip.ip_loadbalancer.id
  zone = "fr-par-1"
  type   = "LB-S"
  release_ip = true
}