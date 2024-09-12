# Reading the manifest files
data "kubectl_file_documents" "argocd-ns" {
  content = file("./manifests/argocd-ns.yaml")
}

data "kubectl_file_documents" "argocd-install" {
  content = file("./manifests/argocd-install.yaml")
}

data "kubectl_file_documents" "argocd-nodeport" {
  content = file("./manifests/argocd-nodeport.yaml")
}

data "kubectl_file_documents" "argocd-github-secret" {
  content = file("./manifests/github-secret.yaml")
}

data "kubectl_file_documents" "cluster-rbac" {
  content = file("./manifests/developer-full-access.yaml")
}


data "kubectl_file_documents" "digitify-applicationset" {
  content = file("./manifests/applicationset-${var.environment}.yaml")
}

## Deploying the manifests

resource "kubectl_manifest" "argocd-ns" {
  count              = length(data.kubectl_file_documents.argocd-ns.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd-ns.documents, count.index)
  override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd-install" {
  depends_on = [
    kubectl_manifest.argocd-ns,
  ]
  count              = length(data.kubectl_file_documents.argocd-install.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd-install.documents, count.index)
  override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd-nodeport" {
  depends_on = [
    kubectl_manifest.argocd-install,
  ]
  count              = length(data.kubectl_file_documents.argocd-nodeport.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd-nodeport.documents, count.index)
  override_namespace = "argocd"
}

resource "kubectl_manifest" "argocd-github-secret" {
  depends_on = [
    kubectl_manifest.argocd-nodeport,
  ]
  count              = length(data.kubectl_file_documents.argocd-github-secret.documents)
  yaml_body          = element(data.kubectl_file_documents.argocd-github-secret.documents, count.index)
  override_namespace = "argocd"
}

resource "kubectl_manifest" "cluster-rbac" {
  depends_on = [
    kubectl_manifest.argocd-github-secret,
  ]
  count     = length(data.kubectl_file_documents.cluster-rbac.documents)
  yaml_body = element(data.kubectl_file_documents.cluster-rbac.documents, count.index)
}

resource "kubectl_manifest" "digitify-applicationset" {
  count              = length(data.kubectl_file_documents.digitify-applicationset.documents)
  yaml_body          = element(data.kubectl_file_documents.digitify-applicationset.documents, count.index)
  override_namespace = "argocd"
}
