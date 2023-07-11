# Azure DevOps Build Definition Terraform module

Terraform module which creates Build Definition in Azure DevOps

## Usage

```terraform
module "build_definition" {
  source = "git::https://github.com/pressreader/terraform-azure-devops-build-definition.git?ref=v1.0.0"

  project_id = "ID of a project"

  name = "Name of a build definition"
  path = "Path (folder) for the build definition" # Defaults to null
  
  agent_pool_name = "Name of an agent pool"

  use_yaml  = True                               # Defaults to True
  yaml_path = "Path to azure-pipelines.yml file" # Defaults to azure-pipelines.yml

  repo_id     = "ID of a repository"
  repo_type   = "TfsGit"           # Defaults to TfsGit
  branch_name = "Name of a branch" # Defaults to main

  variables = [
    {
      name           = "The name of the variable"
      value          = "The value of the variable"
      is_secret      = False                              # Defaults to False.
      secret_value   = "The secret value of the variable" # Defaults to Null
      allow_override = False                              # Defaults to False.
    }
  ]

  schedules = {
    days_to_build = ["When to build"]
    start_hours   = "Build start hour"   # Defaults to 0
    start_minutes = "Build start minute" # Defaults to 0
    time_zone     = "Build time zone"    # Defaults to (UTC-08:00) Pacific Time (US &Canada)
    
    schedule_only_with_changes = "Schedule builds if the source or pipeline has changed" # Defaults to false.
    branch_filter              = "The branches to include and exclude from the trigger"  # Defaults to branch_filter_include = ["main"], branch_filter_exclude = [].
  }
}
```