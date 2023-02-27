resource "google_compute_network" "vpc_network" {
    name = "company-vpc-network"
    auto_create_subnetworks = "false" 
    routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "management_subnet" {
  name          = "management-subnet"
  ip_cidr_range = "192.168.1.0/24"
  region = "us-east1"
  network       = google_compute_network.vpc_network.self_link
  secondary_ip_range  = [
    {
        range_name    = "services"
        ip_cidr_range = "10.10.11.0/24"
    },
    {
        range_name    = "pods"
        ip_cidr_range = "10.1.0.0/20"
    }
  ]

}

# resource "google_compute_subnetwork" "restricted_subnet" {
#   name          = "restricted-subnet"
#   ip_cidr_range = "192.168.2.0/24"
#   network       = google_compute_network.vpc_network.self_link
#   region = "us-east1"
 
# }
resource "google_compute_firewall" "allow-iap-ssh" {
  name    = "allow-iap-ssh-traffic"
  network = google_compute_network.vpc_network.name
  priority = 1000

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
   target_tags         = ["private"]
}


resource "google_compute_router" "management_router" {
  
  name    = "managementrouter"
  network = google_compute_network.vpc_network.name
  project = "saad-375811"
  bgp {
    asn = 64514 
  }
  depends_on = [
    google_compute_network.vpc_network
  ]
}
resource "google_compute_address" "nat_ip" {
  name    = "nat-ip"
}

resource "google_compute_router_nat" "management_nat" {
  name                               = "nat"
  router                             = google_compute_router.management_router.name
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [ google_compute_address.nat_ip.self_link ]
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS" 
  subnetwork {
    name                    = google_compute_subnetwork.management_subnet.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
   depends_on                         = [ google_compute_address.nat_ip]
}

