# resource "aws_vpc" "main" {
#   cidr_block = "10.0.0.0/16"

#   tags = {
#     Name = "terraform-101"
#   }
# }

# resource "aws_subnet" "public_subnet" {
#   vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.0.0/24"

#   availability_zone = "ap-northeast-2a"

#   tags = {
#     Name = "terraform-101-public-subnet"
#   }
# }

# resource "aws_subnet" "private_subnet" {
#   vpc_id = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "terraform-101-private-subnet"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "terraform-101-igw"
#   }
# }

# resource "aws_eip" "nat" {
#   vpc = true

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat.id

#   # Private subnet이 아니라 public subnet을 연결해야한다
#   subnet_id = aws_subnet.public_subnet.id

#   tags = {
#     Name = "terraform-101-nat-gateway"
#   }
# }

# resource "aws_route_table" "public" {
#   vpc_id = aws_vpc.main.id

#   # route inner rules
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "terraform-101-public-route-table"
#   }
# }

# resource "aws_route_table_association" "route_table_associatrion_public" {
#   subnet_id = aws_subnet.public_subnet.id
#   route_table_id = aws_route_table.public.id
# }

# resource "aws_route_table" "private" {
#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name = "terraform-101-private-route-table"
#   }
# }

# resource "aws_route_table_association" "route_table_associatrion_private" {
#   subnet_id = aws_subnet.private_subnet.id
#   route_table_id = aws_route_table.private.id
# }

# # route outer rules
# resource "aws_route" "private_nat" {
#   route_table_id = aws_route_table.private.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id = aws_nat_gateway.nat_gateway.id
# }




