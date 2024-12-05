provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [
      "eks", "get-token", "--profile", "${local.aws_profile_name}", "--region", "eu-west-1", "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.29.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true
  //enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"
  }

  eks_managed_node_groups = tomap({
    for group_name, group_config in var.eks_managed_node_groups : group_name => {
      desired_size   = group_config.desired_size
      max_size       = group_config.max_size
      min_size       = group_config.min_size
      instance_types = group_config.instance_types
      ami_type       = group_config.ami_type
      disk_size      = group_config.disk_size
      tags           = group_config.tags
    }
  })
  manage_aws_auth_configmap = true

  aws_auth_users = [for user in keys(var.admin_users) : {
    username = user
    groups   = ["system:masters"]
    userarn  = data.aws_iam_user.admins[user].arn
  }]

  cluster_security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    # ingress_admission_webhook_controller = {
    #   description                   = "AWS NLB Admission Webhook Controller"
    #   protocol                      = "tcp"
    #   from_port                     = 8443
    #   to_port                       = 8443
    #   type                          = "ingress"
    #   source_cluster_security_group = true
    # }
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    ingress_cluster_all = {
      description                   = "Cluster to node all ports/protocols"
      protocol                      = "-1"
      from_port                     = 0
      to_port                       = 0
      type                          = "ingress"
      source_cluster_security_group = true
    }
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }
}

resource "aws_eks_addon" "addons" {
  for_each = { for addon in local.eks_addons : addon.name => addon
  if !try(addon.use_irsa, false) }
  cluster_name                = data.aws_eks_cluster.cluster.name
  addon_name                  = each.value.name
  addon_version               = each.value.version
  resolve_conflicts_on_update = "OVERWRITE"
  configuration_values        = jsonencode(each.value.configuration_values)
}