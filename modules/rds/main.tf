


resource "aws_db_subnet_group" "db_subnet" {
name = "${var.name}-db-subnet"
subnet_ids = var.private_subnet_ids
}


resource "aws_db_instance" "db" {
identifier = "${var.name}-db"
engine = "mysql"
engine_version = "8.0"
instance_class = "db.t3.micro"
allocated_storage = 20
username = var.db_username
password = var.db_password
db_subnet_group_name = aws_db_subnet_group.db_subnet.name
multi_az = true
publicly_accessible = false
skip_final_snapshot = true
}

