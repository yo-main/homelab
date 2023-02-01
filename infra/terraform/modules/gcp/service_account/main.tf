resource "google_service_account" "main" {
  account_id  = var.service_account_id
  description = var.description
}

resource "google_service_account_iam_member" "dns_role" {
  count              = len(var.roles)
  service_account_id = google_service_account.main.id
  role               = var.roles[count.index]
  members            = var.role_members
}