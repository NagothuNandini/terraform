module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access  = var.endpoint_public_access
  endpoint_private_access = var.endpoint_private_access

  enable_cluster_creator_admin_permissions = var.cluster_admin_permission
  upgrade_policy                           = var.upgrade_policy
  service_ipv4_cidr                        = var.service_cidr

  addons = {
    coredns                = {}
    kube-proxy             = {}
    vpc-cni                = { before_compute = true }
    eks-pod-identity-agent = { before_compute = true }

    aws-ebs-csi-driver = {
      pod_identity_association = [{
        role_arn        = var.ebs_csi_driver_arn
        service_account = "ebs-csi-controller-sa"
      }]
    }
  }

  enable_irsa    = var.enable_irsa
  create_kms_key = var.create_kms_key

  control_plane_subnet_ids = var.private_subnets

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  #access_entries = var.access_entries
  eks_managed_node_groups = var.managed_node_groups


  tags = {
    cluster     = var.cluster_name
    Environment = var.environment
  }
}

