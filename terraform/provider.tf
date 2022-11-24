provider "kubernetes" {
    config_path = "~/.kube/config"
    config_context = "kind-trivy-terraform"
}

provider "helm" {
  kubernetes {
        config_path = "~/.kube/config"
        config_context = "kind-trivy-terraform"
    }
}