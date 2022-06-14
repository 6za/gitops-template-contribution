terraform {
  backend "s3" {
    bucket  = "<TF_STATE_BUCKET>"
    key     = "terraform/vault/tfstate.tf"
    region  = "<AWS_DEFAULT_REGION>"
    encrypt = true
  }
}

module "bootstrap" {
  source = "./bootstrap"

  aws_account_id                    = var.aws_account_id
  aws_region                        = var.aws_region
  aws_secret_access_key             = var.aws_secret_access_key
  vault_token                       = var.vault_token
  email_address                     = var.email_address
  vault_addr                        = var.vault_addr
  aws_access_key_id                 = var.aws_access_key_id
  gitlab_bot_root_password          = var.gitlab_bot_root_password
  hosted_zone_id                    = var.hosted_zone_id
  hosted_zone_name                  = var.hosted_zone_name
  gitlab_runner_token               = var.gitlab_runner_token
  argocd_auth_password              = var.argocd_auth_password
  atlantis_gitlab_token             = var.atlantis_gitlab_token
  atlantis_gitlab_webhook_secret    = var.atlantis_gitlab_webhook_secret
  gitlab_token                      = var.gitlab_token
}

module "oidc" {
  source = "./oidc"

  vault_redirect_uris = var.vault_redirect_uris
}