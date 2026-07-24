module "vpc_dev" {
  source = "../../modules/vpc"

  # Customer Input Values
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  environment     = var.environment
}

module "iam" {
  source       = "../../modules/iam"
  cluster_name = var.cluster_name
}

module "eks" {
  source = "../../modules/eks"

  cluster_name             = var.cluster_name
  kubernetes_version       = var.kubernetes_version
  endpoint_public_access   = var.endpoint_public_access
  endpoint_private_access  = var.endpoint_private_access
  cluster_admin_permission = var.cluster_admin_permission
  upgrade_policy           = var.upgrade_policy
  service_cidr             = var.service_cidr
  enable_irsa              = var.enable_irsa
  create_kms_key           = var.create_kms_key
  environment              = var.environment
  ebs_csi_driver_arn       = module.iam.ebs_csi_driver_arn
  vpc_id                   = module.vpc_dev.vpc_id
  private_subnets          = module.vpc_dev.private_subnet_ids

  managed_node_groups = var.managed_node_groups

  depends_on = [module.vpc_dev]
}


module "application" {
  source = "../../modules/application"

  eks_endpoint           = module.eks.cluster_endpoint
  cluster_ca_certificate = module.eks.cluster_certificate_authority_data
  cluster_token          = module.eks.cluster_auth_token

  # Ensure Helm only attempts deployment AFTER EKS is fully provisioned and ready
  depends_on = [
    module.eks
  ]
}
