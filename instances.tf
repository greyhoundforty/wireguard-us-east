resource "ibm_is_instance" "wireguard_instance" {
  name    = "${var.vpc_name}-wg"
  image   = data.ibm_is_image.default.id
  profile = var.default_instance_profile

  primary_network_interface {
    subnet          = ibm_is_subnet.regional_z1_subnet.id
    security_groups = [ibm_is_security_group.wireguard_security_group.id]
  }

  resource_group = data.ibm_resource_group.rg.id
  tags           = ["ryantiffany", var.region]

  vpc       = ibm_is_vpc.vpc.id
  zone      = data.ibm_is_zones.regional_zones.zones[0]
  keys      = [data.ibm_is_ssh_key.regional_ssh_key.id]
  user_data = templatefile("${path.module}/installer.sh", { client_public_key = var.client_public_key, consul_token = var.consul_token, consul_http = var.consul_http })
}

resource "ibm_is_instance" "z1_instance" {
  name    = "${var.vpc_name}-z1"
  image   = data.ibm_is_image.default.id
  profile = var.default_instance_profile

  primary_network_interface {
    subnet          = ibm_is_subnet.regional_z1_subnet.id
    security_groups = [ibm_is_security_group.service_instance_security_group.id]
  }

  resource_group = data.ibm_resource_group.rg.id
  tags           = ["ryantiffany", var.region]

  vpc       = ibm_is_vpc.vpc.id
  zone      = data.ibm_is_zones.regional_zones.zones[0]
  keys      = [data.ibm_is_ssh_key.regional_ssh_key.id]
  user_data = file("${path.module}/install.yml")
}

resource "ibm_is_instance" "z2_instance" {
  name    = "${var.vpc_name}-z2"
  image   = data.ibm_is_image.default.id
  profile = var.default_instance_profile

  primary_network_interface {
    subnet          = ibm_is_subnet.regional_z2_subnet.id
    security_groups = [ibm_is_security_group.service_instance_security_group.id]
  }

  resource_group = data.ibm_resource_group.rg.id
  tags           = ["ryantiffany", var.region]

  vpc       = ibm_is_vpc.vpc.id
  zone      = data.ibm_is_zones.regional_zones.zones[1]
  keys      = [data.ibm_is_ssh_key.regional_ssh_key.id]
  user_data = file("${path.module}/install.yml")
}

resource "ibm_is_instance" "z3_instance" {
  name    = "${var.vpc_name}-z3"
  image   = data.ibm_is_image.default.id
  profile = var.default_instance_profile

  primary_network_interface {
    subnet          = ibm_is_subnet.regional_z3_subnet.id
    security_groups = [ibm_is_security_group.service_instance_security_group.id]
  }

  resource_group = data.ibm_resource_group.rg.id
  tags           = ["ryantiffany", var.region]

  vpc       = ibm_is_vpc.vpc.id
  zone      = data.ibm_is_zones.regional_zones.zones[2]
  keys      = [data.ibm_is_ssh_key.regional_ssh_key.id]
  user_data = file("${path.module}/install.yml")
}