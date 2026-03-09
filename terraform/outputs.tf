output "cluster_name" {

  value = module.eks.cluster_name
}

output "grafana_access" {

  value = "kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring"
}

output "argocd_access" {

  value = "kubectl port-forward svc/argocd-server 8080:443 -n argocd"
}