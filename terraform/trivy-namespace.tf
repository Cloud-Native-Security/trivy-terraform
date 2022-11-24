resource "kubernetes_namespace" "trivy_system" {
  metadata {
    name = "trivy-system"
  }
}