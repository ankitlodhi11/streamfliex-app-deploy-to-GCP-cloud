resource "google_storage_bucket" "my_bucket" {
  name                        = "aao2352233"
  location                    = "ASIA-SOUTH1"
  force_destroy               = true
  uniform_bucket_level_access = true
}

# 1. Custom VPC Network
resource "google_compute_network" "custom_vpc" {
  name                    = "my-custom-vpc"
  auto_create_subnetworks = false # Best practice: automatic subnets off rakhein
}

# 2. Subnet inside the VPC
resource "google_compute_subnetwork" "custom_subnet" {
  name          = "my-subnet-mumbai"
  ip_cidr_range = "10.0.1.0/24"
  region        = "asia-south1"
  network       = google_compute_network.custom_vpc.id
}

# 3. Firewall Rule (SSH access allow karne ke liye)
resource "google_compute_firewall" "allow_ssh" {
  name    = "my-vpc-allow-ssh"
  network = google_compute_network.custom_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80"]
  }

  source_ranges = ["0.0.0.0/0"] # Production me ise apne specific IP tak restrict karein
  #target_tags   = ["ssh-enabled"]
}

# 2. VM ke access_config me pass karein
resource "google_compute_instance" "vm_instance" {
  depends_on = [ "google_compute_network.custom_vpc", "google_compute_subnetwork.custom_subnet", "google_compute_firewall.allow_ssh" ]
  name         = "my-test-vm"
  machine_type = "e2-micro"
  zone         = "asia-south1-a"
  tags         = ["ssh-enabled"]
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network    = google_compute_network.custom_vpc.id
    subnetwork = google_compute_subnetwork.custom_subnet.id

    access_config {
      #      nat_ip = google_compute_address.static_ip.address # Static IP attach kiya
    }
  }
}


output "vm_public_ip" {
  value       = google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip
  description = "VM ka Public IP address"
}

