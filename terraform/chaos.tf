resource "helm_release" "litmus" {

  name = "litmus"

  repository = "https://litmuschaos.github.io/litmus-helm"

  chart = "litmus"

  namespace = "chaos"

  create_namespace = true
}