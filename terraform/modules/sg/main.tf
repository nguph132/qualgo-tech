resource "aws_security_group" "sg" {
  for_each    = { for idx, v in var.sg_list : v.name => v }
  name        = each.value.name
  description = each.value.description
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "sg_qualgo_backend_rule" {
  for_each = { for k, v in var.sg_qualgo_backend_rules : k => v }
  # Required
  security_group_id = aws_security_group.sg["sg_qualgo_backend"].id
  protocol          = each.value.protocol
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type

  # Optional
  description              = lookup(each.value, "description", null)
  cidr_blocks              = lookup(each.value, "cidr_blocks", null)
  ipv6_cidr_blocks         = lookup(each.value, "ipv6_cidr_blocks", null)
  prefix_list_ids          = lookup(each.value, "prefix_list_ids", null)
  self                     = lookup(each.value, "self", null)
  source_security_group_id = lookup(each.value, "source_security_group_id", null)
}