resource "google_service_account" "service_account" {
  account_id   = "bastion-host-sa"
  display_name = "bastion-serviceA"
}

resource "google_project_iam_member" "attach_permission_to_bastion" {
    project = "saad-375811"
    role = "roles/container.developer"
    member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_project_iam_member" "attach_permission_to_bastion_1" {
    project = "saad-375811"
    role = "roles/container.admin"
    member = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account" "service_account1" {
  account_id   = "gke-host-sa"
  display_name = "gke-serviceA"
}
resource "google_project_iam_member" "attach_permission_to_gke" {
    project = "saad-375811"
    role = "roles/compute.storageAdmin"
    member = "serviceAccount:${google_service_account.service_account1.email}"
}
resource "google_project_iam_member" "attach_permission_to_gke1" {
    project = "saad-375811"
    role = "roles/compute.viewer"
    member = "serviceAccount:${google_service_account.service_account1.email}"
}

resource "google_project_iam_member" "attach_permission_to_gke2" {
    project = "saad-375811"
    role = "roles/container.developer"
    member = "serviceAccount:${google_service_account.service_account1.email}"
}
resource "google_project_iam_member" "attach_permission_to_gke3" {
    project = "saad-375811"
    role = "roles/container.admin"
    member = "serviceAccount:${google_service_account.service_account1.email}"
}
