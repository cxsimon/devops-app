module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0"

  cluster_name    = "devops-task-cluster"
  cluster_version = "1.30"
  create_iam_role = true
  cluster_endpoint_public_access  = true
  create_cloudwatch_log_group = false
  attach_cluster_encryption_policy = false
  create_kms_key = false
  cluster_encryption_config = []
  enable_cluster_creator_admin_permissions = true
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = "vpc-017cfae97a6c84f03" #todo-move-to-variables
  subnet_ids               = ["subnet-0e4e021e41a410c67", "subnet-0b5289d8f876fb36f"]



  eks_managed_node_groups = {
    eks_node_groups = {
      ami_type       = "AL2_x86_64"
      instance_types = ["t2.medium"]
      
      min_size     = 2
      max_size     = 4
      desired_size = 2
    }
  }

tags = {
    devops_task = "true"
  }
}