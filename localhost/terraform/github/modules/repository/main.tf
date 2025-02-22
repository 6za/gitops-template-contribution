terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.26.0"
    }
  }
}

# We need to use some k3d repo magic here
# resource "aws_ecr_repository" "repo" {
#   count                = var.create_ecr != true ? 0 : 1
#   name                 = "${var.repo_name}-<CLUSTER_NAME>"
#   image_tag_mutability = "IMMUTABLE"
#   force_delete         = true

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }

output "repo_name" {
  value = github_repository.repo.name
}

resource "github_repository" "repo" {
  name        = var.repo_name
  description = var.description

  visibility             = var.visibility
  auto_init              = var.auto_init
  archive_on_destroy     = var.archive_on_destroy
  has_issues             = var.has_issues
  is_template            = var.is_template
  homepage_url           = var.homepage_url
  delete_branch_on_merge = var.delete_branch_on_merge
  topics                 = var.topics

  dynamic "template" {
    for_each = length(var.template) != 0 ? [var.template] : []

    content {
      owner      = lookup(template.value, "owner", null)
      repository = lookup(template.value, "repository", null)
    }
  }

  dynamic "pages" {
    for_each = length(var.pages) != 0 ? [var.pages] : []

    content {
      source {
        branch = lookup(pages.value, "branch", null)
        path   = lookup(pages.value, "path", null)
      }
    }
  }
}
# todo add organization support
# resource "github_team_repository" "team_admins" {
#   team_id    = var.team_admins_id
#   repository = github_repository.repo.name
#   permission = "admin"
# }

# resource "github_team_repository" "team_developers" {
#   team_id    = var.team_developers_id
#   repository = github_repository.repo.name
#   permission = "maintain"
# }
