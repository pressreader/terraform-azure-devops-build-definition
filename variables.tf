variable "project_id" {
  description = "Azure DevOps Project ID"
  type        = string
}

variable "name" {
  description = "The name of the build definition."
  type        = string
}

variable "path" {
  description = "The folder path of the build definition. Defaults to null."
  type        = string
  default     = null
}

variable "agent_pool_name" {
  description = "The agent pool that should execute the build. Defaults to Azure Pipelines."
  type        = string
}

variable "use_yaml" {
  description = "Use the azure-pipeline file for the build configuration. Defaults to true."
  type        = bool
  default     = true
}

variable "repo_type" {
  description = "The repository type. Valid values: GitHub or TfsGit or Bitbucket or GitHub Enterprise. If repo_type is GitHubEnterprise, must use existing project and GitHub Enterprise service connection. Defaults to TfsGit."
  type        = string
  default     = "TfsGit"

  validation {
    condition     = contains(["GitHub", "TfsGit", "Bitbucket", "GitHubEnterprise"], var.repo_type)
    error_message = "The repo_type value must be one of GitHub, TfsGit, Bitbucket or GitHubEnterprise."
  }
}

variable "repo_id" {
  description = "The id of the repository. For TfsGit repos, this is simply the ID of the repository. For Github repos, this will take the form of <GitHub Org>/<Repo Name>. For Bitbucket repos, this will take the form of <Workspace ID>/<Repo Name>."
  type        = string
}

variable "branch_name" {
  description = "The branch name for which builds are triggered. Defaults to main."
  type        = string
  default     = "main"
}

variable "yml_path" {
  description = "The path of the Yaml file describing the build definition. Defaults to azure-pipelines.yml."
  type        = string
  default     = "azure-pipelines.yml"
}

variable "variables" {
  description = <<EOF
  <br><b>name:</b> The name of the variable.
  <br><b>value:</b> The value of the variable.
  <br><b>is_secret:</b> True if the variable is a secret. Defaults to false.
  <br><b>secret_value:</b> The secret value of the variable. Used when is_secret set to true.
  <br><b>allow_override:</b> True if the variable can be overridden. Defaults to true.
EOF
  type        = list(object({
    name           = string
    value          = optional(string)
    is_secret      = optional(bool, false)
    secret_value   = optional(string)
    allow_override = optional(bool, false)
  }))
  default = []
}

variable "schedules" {
  description = <<EOF
  <br><b>days_to_build:</b> When to build. Valid values: Mon, Tue, Wed, Thu, Fri, Sat, Sun.
  <br><b>start_hours:</b> Build start hour. Defaults to 0. Valid values: 0 ~ 23.
  <br><b>start_minutes:</b> Build start minute. Defaults to 0. Valid values: 0 ~ 59.
  <br><b>time_zone:</b> Build time zone. Defaults to (UTC-08:00) Pacific Time (US &Canada).
  <br><b>schedule_only_with_changes:</b> Schedule builds if the source or pipeline has changed. Defaults to false.
  <br><b>branch_filter:</b> The branches to include and exclude from the trigger. Defaults to branch_filter_include = ["main"], branch_filter_exclude = [].
EOF
  type        = object({
    enabled                    = optional(bool, true)
    days_to_build              = optional(list(string))
    start_hours                = optional(number, 0)
    start_minutes              = optional(number, 0)
    time_zone                  = optional(string, "(UTC-08:00) Pacific Time (US &Canada)")
    schedule_only_with_changes = optional(bool, false)
    branch_filter_include      = optional(list(string), ["main"])
    branch_filter_exclude      = optional(list(string), [])
  })
  default = { enabled = false }

  validation {
    condition     = alltrue([
      for v in var.schedules.days_to_build :contains(["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"], v)
    ])
    error_message = "The days_to_build value must be one of Mon, Tue, Wed, Thu, Fri, Sat or Sun."
  }

  validation {
    condition     = contains(range(0, 24), var.schedules.start_hours)
    error_message = "The start_hours value must be between 0 - 23."
  }

  validation {
    condition     = contains(range(0, 60), var.schedules.start_minutes)
    error_message = "The start_minutes value must be between 0 - 59."
  }
}