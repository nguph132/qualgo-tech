output qualgo_security_groups_ids {
  value       = { for sg_name, sg in aws_security_group.sg : sg_name => sg.id }
}