data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_iam_user" "admins" {
  for_each  = var.admin_users
  user_name = each.key
}

locals {
  aws_profile_name = "default"
  eks_addons = [
    {
      name                 = "kube-proxy"
      version              = "v1.31.2-eksbuild.3"
      configuration_values = {}
    },
    {
      name    = "vpc-cni"
      version = "v1.19.0-eksbuild.1"
      configuration_values = ({
        enableNetworkPolicy = "true",
        env = {
          ENABLE_POD_ENI = "true"
        }
        init = {
          env = {
            DISABLE_TCP_EARLY_DEMUX = "true"
          }
        }
      })
    },
    {
      name                 = "coredns"
      version              = "v1.11.3-eksbuild.1"
      configuration_values = {}
    },
    {
      name                 = "aws-ebs-csi-driver"
      version              = "v1.37.0-eksbuild.1"
      configuration_values = {}
    },
  ]
}