data "aws_eks_cluster" "cluster" {
  name = aws_eks_cluster.my_cluster.name
}

data "aws_eks_cluster_auth" "cluster" {
  name = aws_eks_cluster.my_cluster.name
}

provider "kubernetes" {

  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)

  config_path    = "~/.kube/config"
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = "first-namespace"
  }
}

resource "kubernetes_deployment" "app_deployment" {
  metadata {
    name = "webapp"
    namespace = kubernetes_namespace.app_namespace.metadata.0.name
    
    labels = {
      app = "webapp"

    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "webapp"
      }
    }

    template {
      metadata {

        labels = {
            app = "webapp"
        }
      }
      
      spec {

        container {

          image = "<your_ECR_repo_URL>"
          name  = "mycontainer"

          port {
            container_port = 80
          }

          resources {

            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }

            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
        }
    }
}




}

}

}
