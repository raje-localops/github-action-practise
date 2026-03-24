module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Node groups
  eks_managed_node_groups = {
    general = {
      min_size       = 1
      max_size       = 4
      desired_size   = 2
      instance_types = ["t3.medium"]
      capacity_type  = "ON_DEMAND"

      labels = {
        role = "general"
      }
    }

    spot = {
      min_size       = 0
      max_size       = 4
      desired_size   = 1
      instance_types = ["t3.medium", "t3.large"]
      capacity_type  = "SPOT"

      labels = {
        role = "spot"
      }
    }
  }

  tags = {
    Environment = var.environment
    Terraform   = "true"
  }
}
