resource "helm_release" "prometheus" {

  name = "monitoring"

  repository = "https://prometheus-community.github.io/helm-charts"

  chart = "kube-prometheus-stack"

  namespace = "monitoring"

  create_namespace = true
}