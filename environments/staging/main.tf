module "vpc_dev" {
  source = "../../modules/vpc"

  # Customer Input Values
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  environment = var.environment
}

module "eks" {
  source = "../..//modules/eks"

  cluster_name              = var.cluster_name
  kubernetes_version        = var.kubernetes_version
  endpoint_public_access    = var.endpoint_public_access
  endpoint_private_access   = var.endpoint_private_access
  cluster_admin_permission  = var.cluster_admin_permission
  upgrade_policy            = var.upgrade_policy
  service_cidr              = var.service_cidr
  enable_irsa               = var.enable_irsa
  create_kms_key            = var.create_kms_key
  environment               = var.environment

  vpc_id          = module.vpc_dev.vpc_id
  private_subnets = module.vpc_dev.private_subnet_ids

  managed_node_groups = var.managed_node_groups
  fargate_profiles = var.fargate_profiles

  depends_on = [module.vpc_dev]
}

