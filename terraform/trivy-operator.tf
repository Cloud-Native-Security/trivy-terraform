resource "helm_release" "trivy_helm" {
  name       = "trivy-operator"
  namespace  = kubernetes_namespace.trivy_system.metadata.0.name

  repository = "https://aquasecurity.github.io/helm-charts/"
  chart      = "trivy-operator"

  values = [
    "${file("values.yaml")}"
  ]
}

