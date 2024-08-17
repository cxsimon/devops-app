resource "aws_iam_policy" "alb_ingress_controller_policy" {
  name        = "DevopsTaskALBIngressControllerIAMPolicy"
  description = "Policy for the ALB Ingress Controller"
  policy      = file("iam_policy.json") 
  tags = {
    devops_task = "true"
  }
}

resource "aws_iam_role" "alb_ingress_controller_role" {
  name = "alb-ingress-controller"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Principal" : {
        "Federated" : "arn:aws:iam::851725552187:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/193BE6CD92D1023022CBC460029966B6"
      },
      "Action" : "sts:AssumeRoleWithWebIdentity",
      "Condition" : {
        "StringEquals" : {
          "oidc.eks.us-east-2.amazonaws.com/id/193BE6CD92D1023022CBC460029966B6:sub" : "system:serviceaccount:kube-system:alb-ingress-controller"
        }
      }
    }]
  })
  tags = {
    devops_task = "true"
  }
}
resource "aws_iam_role_policy_attachment" "alb_ingress_controller_role_attachment" {
  role       = aws_iam_role.alb_ingress_controller_role.name
  policy_arn = aws_iam_policy.alb_ingress_controller_policy.arn
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_path = "~/.kube/config"  
}

resource "kubernetes_service_account" "alb_ingress_controller" {
  metadata {
    name      = "alb-ingress-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.alb_ingress_controller_role.arn
    }
  }
}
resource "helm_release" "alb_ingress_controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"

  values = [
    <<EOF
    clusterName: "devops-task-cluster"
    serviceAccount:
      create: false
      name: alb-ingress-controller
    region: "us-east-2"
    vpcId: "vpc-017cfae97a6c84f03"
    EOF
  ]
}

