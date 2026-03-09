resource "helm_release" "otel" {

  name = "opentelemetry"

  repository = "https://open-telemetry.github.io/opentelemetry-helm-charts"

  chart = "opentelemetry-collector"

  namespace = "observability"

  create_namespace = true
}