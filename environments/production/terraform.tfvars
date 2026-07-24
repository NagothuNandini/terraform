vpc_name                 = "prod-env-vpc"
vpc_cidr                 = "10.1.0.0/16"
public_subnets           = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnets          = ["10.1.100.0/24", "10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24", "10.1.104.0/24"]
environment              = "dev"
cluster_name             = "prod-eks-cluster"
kubernetes_version       = "1.35"
endpoint_public_access   = false
endpoint_private_access  = true
cluster_admin_permission = false
upgrade_policy = {
  support_type = "EXTENDED"
}
service_cidr   = "172.20.0.0/16"
enable_irsa    = true
create_kms_key = true
managed_node_groups = {
  general = {
    name           = "general-ng"
    min_size       = 3
    max_size       = 5
    desired_size   = 3
    instance_types = ["t3."]
    capacity_type  = "ON_DEMAND"
  }
}

fargate_profiles = {
  default = {
    name = "default-fg"
    selectors = [{
      namespace = "default"
    }]
  },
  test = {
    name = "test-fg"
    selectors = [{
      namespace = "test"
    }]
  }
}
access_entries = {
  platform_admins = {
    principal_arn = "arn:aws:iam::123456789012:role/platform-admins"
    policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    scope_type    = "cluster"
  }
}

