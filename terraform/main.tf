module "iam" {
  source = "./modules/iam"
  users = {
    "qualgo-ci" = [
      {
        Effect   = "Allow"
        Action   = ["eks:*", "ecr:*", "autoscaling:*", "ec2:*"]
        Resource = ["*"]
      }
  ] }
}

module "ecr" {
  source              = "./modules/ecr"
  qualgo_repositories = ["qualgo-backend", "qualgo-frontend"]
}

module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = "${local.project}-eks-vpc"
  vpc_cidr        = "10.0.0.0/16"
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

module "sg" {
  source          = "./modules/sg"
  vpc_id          = module.vpc.vpc_id
  sg_list = [
    {
      name        = "sg_qualgo_backend",
      description = "SG for Backend service"
    }
  ]
  sg_qualgo_backend_rules = {
    ingress_nodes_all = {
      description = "Ingress: Allow all traffic from the worker security group (required for probes to work)."
      protocol    = "-1"
      from_port   = 0
      to_port     = 65535
      type        = "ingress"
      cidr_blocks = ["10.0.0.0/16"]
    }
    engress_nodes_all = {
      description = "Engress: Allow all outbound traffic"
      protocol    = "-1"
      from_port   = 0
      to_port     = 65535
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

module "mysql" {
  source              = "./modules/rds-mysql"
  database_name       = "qualgo"
  subnet_ids          = module.vpc.private_subnets
  vpc_id              = module.vpc.vpc_id
  allowed_source_security_group_id = [module.sg.qualgo_security_groups_ids["sg_qualgo_backend"]]
  allowed_cidr_blocks = ["10.0.0.0/16"]
  mysql_parameters = {
    max_connections = {
      name  = "max_connections"
      value = "10"
    }
  }
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "${local.project}-eks"
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets
  cluster_version = local.cluster_version
  eks_managed_node_groups = {
    "qualgo-ng01" = {
      name           = "qualgo-ng01"
      instance_types = ["t3.medium"]
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      ami_type       = "AL2_x86_64"
      disk_size      = "20"
      tags = {
        "k8s.io/cluster-autoscaler/${local.project}-eks" = "owned"
        "k8s.io/cluster-autoscaler/enabled"              = "true"
      }
    }
  }
  admin_users = {
    "qualgo-ci" = {}
  }
}

module "api_gateway" {
  source = "./modules/apigateway"
  # update this url after installing ingress nginx controller
  qualgo_backend_integration_uri = "http://a0bee6bb2e01541d59b396d1e3d7d54b-220837439.ap-southeast-1.elb.amazonaws.com"
}

