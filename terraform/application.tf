resource "kubernetes_namespace" "demo" {

  metadata {

    name = "sre-demo"
  }
}

resource "kubernetes_deployment" "demo_app" {

  metadata {

    name = "demo-app"

    namespace = kubernetes_namespace.demo.metadata[0].name
  }

  spec {

    replicas = 3

    selector {

      match_labels = {

        app = "demo"
      }
    }

    template {

      metadata {

        labels = {

          app = "demo"
        }
      }

      spec {

        container {

          name = "nginx"

          image = "nginx"

          port {

            container_port = 80
          }
        }
      }
    }
  }
}