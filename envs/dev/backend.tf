

terraform {
  backend "s3" {
    bucket = "terraform-3ha-shubh-2204"
    key    = "envs/dev/terraform.tfstate"
    region = "ap-south-1"
    # dynamodb_table = "terraform-state-lock" # optional
  }
}
