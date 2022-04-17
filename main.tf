
locals {
  mandatory_tag = {
    line_of_business        = "terrafom"
    ado                     = "app"
    tier                    = "WEB"
    operational_environment = upper(terraform.workspace)
    tech_poc_primary        = "aminkengc78@gmail.com"
    tech_poc_secondary      = "aminkengc78@gmail.com"
    application             = "http"
    builder                 = "aminkengc78@gmail.com"
    application_owner       = "kojitechs.com"
    vpc                     = "WEB"
    cell_name               = "WEB"
    component_name          = var.component-name

  }
  vpc_id    = aws_vpc.kojitechs[0].id
  creat_vpc = var.creatvpc
  azs       = data.aws_availability_zones.available.names
}
data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_vpc" "kojitechs" {
  count                = local.creat_vpc ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

}
resource "aws_internet_gateway" "igw" {
  count  = local.creat_vpc ? 1 : 0
  vpc_id = local.vpc_id

}
resource "aws_subnet" "public_subnet" {
  count                   = local.creat_vpc ? length(var.pub_subnetcidr) : 0
  vpc_id                  = local.vpc_id
  cidr_block              = var.pub_subnetcidr[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true


  tags = {
    "Name" = "public-subnet-${local.azs[count.index]}"
  }
}
#Deprecated 

output "pub_deprecated" {
  value = aws_subnet.public_subnet.*.id
}

# for loop 

output "pub_id_with_forloop" {
  value = [for ids in aws_subnet.public_subnet : ids.id]
}

resource "aws_subnet" "priv_subnet" {
  count                   = local.creat_vpc ? length(var.private_subnetcidr) : 0
  vpc_id                  = local.vpc_id
  cidr_block              = var.private_subnetcidr[count.index]
  map_public_ip_on_launch = true
  availability_zone       = local.azs[count.index]

  tags = {
    "Name" = "public-subnet-${local.azs[count.index]}"
  }

}
resource "aws_subnet" "database_subnet" {
  count             = local.creat_vpc ? length(var.database_subnetcidr) : 0
  vpc_id            = local.vpc_id
  cidr_block        = var.database_subnetcidr[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    "Name" = "public-subnet-${local.azs[count.index]}"
  }

}

# creating routes
resource "aws_route_table" "route_table" {
  count = local.creat_vpc ? length(var.pub_subnetcidr) : 0

  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }

}
#route table association
resource "aws_route_table_association" "route_table_ass" {
  count = local.creat_vpc ? length(var.pub_subnetcidr) : 0

  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.route_table[0].id
}

resource "aws_default_route_table" "default_route" {
  count = local.creat_vpc ? 1 : 0

  default_route_table_id = aws_vpc.kojitechs[0].default_route_table_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1[0].id
  }

}
resource "aws_eip" "eip" {
  count      = local.creat_vpc ? 1 : 0
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}
# creating nat gateway
resource "aws_nat_gateway" "ngw_1" {
  count         = local.creat_vpc ? 1 : 0
  allocation_id = aws_eip.eip[0].id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "gw NAT"
  }

  depends_on = [aws_internet_gateway.igw]
}

