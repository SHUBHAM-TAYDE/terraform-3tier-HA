# Terraform 3-Tier High Availability Architecture

This repository contains a complete working Terraform repo for a 3-tier, high-availability infrastructure on AWS (dev environment). It uses modules and an envs/dev wrapper. The code is meant for learning and test/dev usage — do not use in production without reviewing security and cost implications.


---

## Step 1: Prepare AWS Backend (S3 + DynamoDB)

If you already created the S3 bucket using the `global/` code, skip this step.

Otherwise run this once:

```bash
cd global
terraform init
terraform apply -var="bucket_name=<your-unique-bucket-name>"
```
This will create:

S3 bucket for Terraform state

DynamoDB table (optional) for state locking


## Step 2: Update Backend for Dev Environment

Edit the file:

```bash
envs/dev/backend.tf
```
Replace:

```bash
<YOUR_TFSTATE_BUCKET>
```
with your actual bucket name.

Example

```bash
bucket = "shubham-tfstate-bucket"
```
