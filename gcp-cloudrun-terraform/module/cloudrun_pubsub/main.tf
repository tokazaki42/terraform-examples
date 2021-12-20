# 参考：
# https://cloud.google.com/run/docs/tutorials/pubsub?utm_campaign=CDR_ahm_aap-severless_cloud-run-faq_&utm_source=external&utm_medium=web#run_pubsub_dockerfile-python

locals {
  region   = "asia-northeast1"
  env_name = "sandbox"
}

################################################
# Pub/Sub
################################################

resource "google_pubsub_topic" "this" {
  name = var.cloudrun_service_name
}

resource "google_pubsub_subscription" "this" {
  name  = var.cloudrun_service_name
  topic = google_pubsub_topic.this.name

  ack_deadline_seconds = 20

  push_config {
    push_endpoint = google_cloud_run_service.this.status[0].url

    oidc_token {
      service_account_email = var.pubsub_invoker_account_email
    }
  }
}

################################################
# IAM
################################################

################################################
# Cloud Run
################################################
resource "google_cloud_run_service" "this" {
  name     = var.cloudrun_service_name
  location = local.region

  template {
    spec {
      containers {
        image = var.gcr_image
      }
    }
  }
}

# 呼び出し元のcloud-run-pubsub-invokerアカウントに、CloudRunサービスを呼び出すための権限を付与
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "serviceAccount:cloud-run-pubsub-invoker@YOUR_PROJECT.iam.gserviceaccount.com",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.this.location
  project  = google_cloud_run_service.this.project
  service  = google_cloud_run_service.this.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

