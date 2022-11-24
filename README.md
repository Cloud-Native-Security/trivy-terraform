## Installing the Trivy Operator through Terraform

Terraform is one of the most popular IaC tools available. In this tutorial, we will showcase how you can easly install the Trivy Operator Helm Chart through Terraform.

Here is the [video tutorial.]()

### Prerequisites

* Access to a Kubernetes cluster, either locally or managed
* The [terraform CLI installed]()

### Set up a the Helm Provier

First, you need to create a provider file. 

`Providers are a logical abstraction of an upstream API. They are responsible for understanding API interactions and exposing resources.` [Source](https://registry.terraform.io/browse/providers)

In our example, we are setting up the Helm provider to connect with the current cluster in our kubeconfig. However, you could also connect it to the cluster in your cloud account. Different cloud providers have different Terraform providers that allow you to connect to their services.

Here is our `provider.tf` file:
```
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
```

### Set up the Trivy Operator Helm Chart

Trivy is installed in the trivy-system namespace. This is another resource that we will manage through terraform rather than creating manually.

For this, we are creating a new file: `trivy-namespace.tf`
```
resource "kubernetes_namespace" "trivy_system" {
  metadata {
    name = "trivy-system"
  }
}
```

The trivy-operator can be installed through the following Terraform configuration: `trivy-operator.tf`
```
resource "helm_release" "trivy_helm" {
  name       = "trivy-helm"
  namespace  = kubernetes_namespace.trivy_system.metadata.0.name

  repository = "https://aquasecurity.github.io/helm-charts/"
  chart      = "trivy-operator"
}
```

### Configure custom values for the Helm Chart

There are two ways that you can go about configuring the Helm Chart values. If you just want to change one parameter, you can set it in the same file as the operator by adding the following lines within the `{}` brackets:
```
set {
    name  = "trivy.ignoreUnfixed"
    value = "true"
  }
```

Alternatively, you can pass in a separate values.yaml file. Specify the file in  within the `{}`:
```
values = [
    "${file("values.yaml")}"
  ]
```

This will allow you to specify all the values in a separate `values.yaml` file:
```
trivy:
      ignoreUnfixed: true
```

### Plan and apply the resources

First, we have to initialise the directory for Terraform with the following CLI command:
```
terraform init
```

Then we can have a dry-run of applying our resources:
```
terraform plan
```

This will showcase everything that will be changed in our infrastructure.
If we are happy with the changes, we can then go ahead and apply the changes -- you will be asked for approval again:
```
terraform apply
```

Once the command completed, you can view the Trivy Operator in the trivy-system namespace inside of your cluster.