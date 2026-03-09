module "eks" {

  source = "terraform-aws-modules/eks/aws"

  cluster_name = var.cluster_name

  cluster_version = "1.29"

  vpc_id = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {

    workers = {

      instance_types = ["t3.large"]

      desired_size = 3

      min_size = 2

      max_size = 4
    }
  }

  tags = local.tags
}