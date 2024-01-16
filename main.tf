
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



###############	Commands to Use ############################################

terraform init
terraform plan
terraform apply    or terraform --auto-approve
