locals {
  region   = "asia-northeast1"
}


################################################
# IAM
################################################

# Pub/Sub サブスクリプションの ID を表すサービス アカウントを作成
resource "google_service_account" "cloud-run-pubsub-invoker" {
  project      = var.project_id
  account_id   = "cloud-run-pubsub-invoker"
  display_name = "Cloud Run Pub/Sub Invoker"
  description  = "managed by terraform"
}

# Pub/Sub がプロジェクトで認証トークンを作成できるようにする。
data "google_iam_policy" "token_creator" {
  binding {
    role = "roles/iam.serviceAccountTokenCreator"

    members = [
      "serviceAccount:cloud-run-pubsub-invoker@YOUR_PROJECT.iam.gserviceaccount.com",
    ]
  }
}
resource "google_service_account_iam_policy" "pubsub_token_creator-account-iam" {
  service_account_id = google_service_account.cloud-run-pubsub-invoker.name
  policy_data        = data.google_iam_policy.token_creator.policy_data
}

################################################
# Cloud Run
################################################

module "golang" {
  source = "../module/cloudrun_pubsub"
  project_id = var.project_id
  pubsub_invoker_account_email = google_service_account.cloud-run-pubsub-invoker.email
  cloudrun_service_name = "golang-cloudrun-example"
  gcr_image = "gcr.io/${var.project_id}/golang-cloudrun-example"
}

module "python" {
  source = "../module/cloudrun_pubsub"
  project_id = var.project_id
  pubsub_invoker_account_email = google_service_account.cloud-run-pubsub-invoker.email
  cloudrun_service_name = "python-cloudrun-example"
  gcr_image = "gcr.io/${var.project_id}/python-cloudrun-example"
}