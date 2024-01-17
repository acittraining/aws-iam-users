
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
To modify the Terraform configuration to use variables, you'll need to declare variables in a variables.tf file and then use these variables in your main.tf file. This approach makes your configuration more flexible and reusable.

Let's define the necessary variables and update the main.tf file accordingly.

variables.tf
Create a new file named variables.tf and add the following variable definitions:

variable "region" {
  description = "The AWS region to create resources in"
  default     = "us-west-2"
}

variable "iam_users" {
  description = "List of IAM users to create"
  type        = list(string)
  default     = ["sammy", "blossom"]
}

variable "iam_groups" {
  description = "List of IAM groups to create"
  type = map(object({
    name      : string
    policies  : list(string)
    members   : list(string)
  }))
  default = {
    "SOC" = {
      name     : "SOC",
      policies : ["IAMFullAccess", "IAMUserChangePassword", "AmazonEC2ReadOnlyAccess"],
      members  : ["blossom"]
    },
    "CNOC" = {
      name     : "CNOC",
      policies : ["AmazonEC2FullAccess", "IAMUserChangePassword", "AmazonS3FullAccess", "IAMReadOnlyAccess"],
      members  : ["sammy"]
    }
  }
}
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

2. Update main.tf
Now, update your main.tf to use these variables. Replace the content of your existing main.tf with the following:

provider "aws" {
  region = var.region
}

resource "aws_iam_user" "user" {
  for_each = toset(var.iam_users)
  name     = each.value
}

resource "aws_iam_group" "group" {
  for_each = var.iam_groups
  name     = each.value.name
}

resource "aws_iam_group_membership" "group_membership" {
  for_each = var.iam_groups

  name   = "group_membership_${each.key}"
  users  = each.value.members
  group = aws_iam_group.group[each.key].name
}

resource "aws_iam_group_policy_attachment" "group_policy_attachment" {
  for_each = { for group_name, group in var.iam_groups : group_name => group.policies }

  dynamic "attachment" {
    for_each = toset(each.value)
    content {
      group      = aws_iam_group.group[each.key].name
      policy_arn = "arn:aws:iam::aws:policy/${attachment.value}"
    }
  }
}

resource "aws_iam_user_login_profile" "user_login_profile" {
  for_each = toset(var.iam_users)

  user                    = each.value
  password_reset_required = true
}
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

3. Execution Steps
Initialization: Run terraform init.
Planning: Execute terraform plan.
Applying: Run terraform apply.
These modifications make your Terraform configuration more modular and maintainable, especially if you need to manage multiple users and groups with varying policies.

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
