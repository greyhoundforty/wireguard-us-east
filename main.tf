resource "ibm_is_vpc" "vpc" {
  name           = var.vpc_name
  resource_group = data.ibm_resource_group.rg.id
  tags           = [var.region, "ryantiffany"]
}