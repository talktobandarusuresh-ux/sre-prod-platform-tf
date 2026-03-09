resource "helm_release" "elasticsearch" {

  name = "elasticsearch"

  repository = "https://helm.elastic.co"

  chart = "elasticsearch"

  namespace = "logging"

  create_namespace = true
}

resource "helm_release" "kibana" {

  name = "kibana"

  repository = "https://helm.elastic.co"

  chart = "kibana"

  namespace = "logging"
}