
#Automating 	IAM USERS, Groups and Policies attachment Using Terraform

provider "aws" {
  region = "us-west-2" # Change this to your desired AWS region
}

resource "aws_iam_user" "sammy" {
  name = "sammy"
}

resource "aws_iam_user" "blossom" {
  name = "blossom"
}

resource "aws_iam_group" "SOC" {
  name = "SOC"
}

resource "aws_iam_group" "CNOC" {
  name = "CNOC"
}

resource "aws_iam_group_membership" "group_membership_SOC" {
  name = "group_membership_SOC"
  users = [aws_iam_user.blossom.name]
  group = aws_iam_group.SOC.name
}

resource "aws_iam_group_membership" "group_membership_CNOC" {
  name = "group_membership_CNOC"
  users = [aws_iam_user.sammy.name]
  group = aws_iam_group.CNOC.name
}

resource "aws_iam_group_policy_attachment" "SOC_IAMFullAccess" {
  group      = aws_iam_group.SOC.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}

resource "aws_iam_group_policy_attachment" "CNOC_EC2FullAccess" {
  group      = aws_iam_group.CNOC.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_group_policy_attachment" "SOC_UserChangePassword" {
  group      = aws_iam_group.SOC.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_group_policy_attachment" "CNOC_UserChangePassword" {
  group      = aws_iam_group.CNOC.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}

resource "aws_iam_group_policy_attachment" "CNOC_S3FullAccess" {
  group      = aws_iam_group.CNOC.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_group_policy_attachment" "CNOC_IAMReadOnlyAccess" {
  group      = aws_iam_group.CNOC.name
  policy_arn = "arn:aws:iam::aws:policy/IAMReadOnlyAccess"
}

resource "aws_iam_group_policy_attachment" "SOC_EC2ReadOnlyAccess" {
  group      = aws_iam_group.SOC.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_iam_user_login_profile" "sammy" {
  user    = aws_iam_user.sammy.name
  password_reset_required = true
}

resource "aws_iam_user_login_profile" "blossom" {
  user    = aws_iam_user.blossom.name
  password_reset_required = true
}


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
###############	Commands to Use ############################################

terraform init
terraform plan
terraform apply    or terraform --auto-approve

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

#############################################################################  Executing the Terraform Configuration #########################################################################################################################
#Initialization: Run terraform init in your Terraform directory. This command initializes Terraform, downloads the AWS provider, and prepares your configuration for execution.

#Planning: Execute terraform plan to see what resources Terraform will create or modify. This step doesn't make any changes to your actual infrastructure but shows what will happen when you apply the configuration.

#Applying: Run terraform apply to apply the configuration. Terraform will ask for confirmation before proceeding. Once confirmed, it will create the IAM users, groups, and attach the necessary policies as defined in the configuration.

#Verification: After the apply completes, you can check your AWS console to verify that the resources were created as expected.

#Destroy (Optional): If you want to remove all resources created by this Terraform configuration, you can run terraform destroy. This will delete all resources managed by this Terraform configuration from your AWS account.

*********************************************************  Remember to review and adjust the region or any other parameters in the Terraform configuration as per your requirements.******************************************************************
