
resource "aws_subnet" "public" {
  count = length(var.PublicSubnetCIDRs)

  vpc_id     = aws_vpc.main.id
  cidr_block = var.PublicSubnetCIDRs[count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  map_public_ip_on_launch         = true
  map_customer_owned_ip_on_launch = false
  customer_owned_ipv4_pool        = ""
  outpost_arn                     = ""

  tags = {
    Name = "${var.EnvironmentName}-Public-Subnet-${upper(substr(data.aws_availability_zones.available.names[count.index], length(data.aws_availability_zones.available.names[count.index]) -1, 1))}"
  }
}

 //--------------------------------------------------

 resource "aws_subnet" "private" {
   count = length(var.PrivateSubnetCIDRs)

   vpc_id     = aws_vpc.main.id
   cidr_block = var.PrivateSubnetCIDRs[count.index]

   availability_zone = data.aws_availability_zones.available.names[count.index]

   map_public_ip_on_launch         = false
   map_customer_owned_ip_on_launch = false
   customer_owned_ipv4_pool        = ""
   outpost_arn                     = ""

  tags = {
    Name = "${var.EnvironmentName}-Private-Subnet-${upper(substr(data.aws_availability_zones.available.names[count.index], length(data.aws_availability_zones.available.names[count.index]) -1, 1))}"
  }
 }

output "PublicSubnets"{
  value=aws_subnet.public
}

resource "aws_db_subnet_group" "private" {
  subnet_ids = aws_subnet.private[*].id
  description = "aurora-private"
  name        = "aurora-private"
  tags        = {}
  tags_all    = {}

}
