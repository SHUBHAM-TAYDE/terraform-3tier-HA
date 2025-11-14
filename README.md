terraform-3tier-ha-repo

This repository contains a complete working Terraform repo for a 3-tier, high-availability infrastructure on AWS (dev environment). It uses modules and an envs/dev wrapper. The code is meant for learning and test/dev usage — do not use in production without reviewing security and cost implications.

terraform-3tier-ha-repo/
├── global/
│ └── s3_backend_setup.tf
├── modules/
│ ├── vpc/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ ├── alb/
│ │ ├── main.tf
│ │ ├── variables.tf
│ │ └── outputs.tf
│ ├── asg_app/
│ │ ├── main.tf
│ │ ├── user_data.sh.tpl
│ │ ├── variables.tf
│ │ └── outputs.tf
│ └── rds/
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
├── envs/
│ └── dev/
│ ├── backend.tf
│ ├── provider.tf
│ ├── main.tf
│ ├── variables.tf
│ └── outputs.tf
└── README.md