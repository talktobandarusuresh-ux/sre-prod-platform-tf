resource "kubernetes_config_map" "slo_rules" {

  metadata {

    name = "slo-rules"

    namespace = "monitoring"
  }

  data = {

    "slo.yaml" = <<EOF

groups:

- name: slo

  rules:

  - alert: ErrorBudgetBurn

    expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.01

    for: 2m

    labels:

      severity: critical

EOF
  }
}