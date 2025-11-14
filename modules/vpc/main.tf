variable "name" {}
resource "aws_vpc" "this" {
cidr_block = var.vpc_cidr
enable_dns_hostnames = true
tags = { Name = "${var.name}-vpc" }
}


# Public subnets (one per AZ)
resource "aws_subnet" "public" {
for_each = toset(var.azs)
vpc_id = aws_vpc.this.id
cidr_block = cidrsubnet(var.vpc_cidr, 8, index(var.azs, each.key))
availability_zone = each.key
map_public_ip_on_launch = true
tags = { Name = "${var.name}-public-${each.key}" }
}


# Private subnets (one per AZ)
resource "aws_subnet" "private" {
for_each = toset(var.azs)
vpc_id = aws_vpc.this.id
cidr_block = cidrsubnet(var.vpc_cidr, 8, length(var.azs) + index(var.azs, each.key))
availability_zone = each.key
tags = { Name = "${var.name}-private-${each.key}" }
}


resource "aws_internet_gateway" "igw" {
vpc_id = aws_vpc.this.id
tags = { Name = "${var.name}-igw" }
}


resource "aws_route_table" "public" {
vpc_id = aws_vpc.this.id
route {
cidr_block = "0.0.0.0/0"
gateway_id = aws_internet_gateway.igw.id
}
tags = { Name = "${var.name}-public-rt" }
}


resource "aws_route_table_association" "public_assoc" {
for_each = aws_subnet.public
subnet_id = each.value.id
route_table_id = aws_route_table.public.id
}


# NAT Gateway (single NAT for dev) — for HA use one NAT/gw per AZ
resource "aws_eip" "nat_eip" {
tags = { Name = "${var.name}-nat-eip" }
}


resource "aws_nat_gateway" "nat" {
allocation_id = aws_eip.nat_eip.id
subnet_id = values(aws_subnet.public)[0].id
tags = { Name = "${var.name}-nat" }
}


resource "aws_route_table" "private" {
vpc_id = aws_vpc.this.id
route {
cidr_block = "0.0.0.0/0"
nat_gateway_id = aws_nat_gateway.nat.id
}
tags = { Name = "${var.name}-private-rt" }
}


resource "aws_route_table_association" "private_assoc" {
for_each = aws_subnet.private
subnet_id = each.value.id
route_table_id = aws_route_table.private.id
}


output "vpc_id" {
     value = aws_vpc.this.id 
     }
output "public_subnet_ids" { 
    value = [for s in aws_subnet.public: s.id] 
    }
output "private_subnet_ids" { 
    value = [for s in aws_subnet.private: s.id] 
    }