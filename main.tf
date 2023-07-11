resource "azuredevops_build_definition" "main" {
  project_id      = var.project_id
  name            = var.name
  path            = var.path != null ? "\\${var.path}" : var.path
  agent_pool_name = var.agent_pool_name

  ci_trigger {
    use_yaml = var.use_yaml
  }

  repository {
    repo_type   = var.repo_type
    repo_id     = var.repo_id
    branch_name = "refs/heads/${var.branch_name}"
    yml_path    = var.yml_path
  }

  dynamic "variable" {
    for_each = {for v in var.variables : v["name"] => v}

    content {
      name           = variable.value["name"]
      value          = variable.value["value"]
      is_secret      = variable.value["is_secret"]
      secret_value   = variable.value["secret_value"]
      allow_override = variable.value["allow_override"]
    }
  }

  dynamic "schedules" {
    for_each = var.schedules.enabled ? [1] : []
    content {
      days_to_build              = var.schedules.days_to_build
      start_hours                = var.schedules.start_hours
      start_minutes              = var.schedules.start_minutes
      time_zone                  = var.schedules.time_zone
      schedule_only_with_changes = var.schedules.schedule_only_with_changes

      branch_filter {
        include = var.schedules.branch_filter_include
        exclude = var.schedules.branch_filter_exclude
      }
    }
  }
}