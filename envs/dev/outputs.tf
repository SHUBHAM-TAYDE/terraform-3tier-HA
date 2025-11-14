output "alb_dns" {
  value = module.alb.alb_dns
}

output "asg_name" {
  value = module.asg.asg_name
}

output "rds_endpoint" {
  value = module.rds.db_endpoint
}
