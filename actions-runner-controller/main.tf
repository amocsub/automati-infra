resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  repository       = "https://charts.jetstack.io"
  namespace        = "cert-manager"
  version          = "1.12.1"
  create_namespace = true
  cleanup_on_fail  = true
  set {
    name  = "installCRDs"
    value = "true"
  }
  set {
    name  = "global.leaderElection.namespace"
    value = "cert-manager"
  }
}

resource "helm_release" "actions-runner-controller-public" {
  name             = "actions-runner-controller-public"
  chart            = "actions-runner-controller"
  repository       = "https://actions-runner-controller.github.io/actions-runner-controller"
  namespace        = "actions-runner-system"
  version          = "0.23.3"
  create_namespace = true
  cleanup_on_fail  = true
  
  set_list {
    name = "labels"
    value = ["automati"]
  }

  set {
    name = "authSecret.create"
    value = true
    type = "auto"
  }

  set_sensitive {
    name = "authSecret.github_app_id"
    value = var.github_app_id
  }

  set_sensitive {
    name = "authSecret.github_app_installation_id"
    value = var.github_app_installation_id
  }

  set_sensitive {
    name = "authSecret.github_app_private_key"
    value = file("${var.github_app_private_key}")
  }

  set {
    name = "image.actionsRunnerRepositoryAndTag"
    value = var.runner_docker_image
  }

  set {
    name = "runner.statusUpdateHook.enabled"
    value = true
    type = "auto"
  }

  set {
    name = "serviceAccount.create"
    value = true
    type = "auto"
  }

  set {
    name = "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = "automati-k8s-sa@${var.project_id}.iam.gserviceaccount.com"
  }

  set {
    name = "serviceAccount.name"
    value = "automati-k8s-sa"
  }

  set {
    name = "securityContext.privileged"
    value = false
    type = "auto"
  }

  set {
    name = "resources.requests.cpu"
    value = var.max_runner_cpu
  }

  set {
    name = "resources.requests.memory"
    value = var.max_runner_memory
  }

  set {
    name = "resources.requests.ephemeral-storage"
    value = var.max_runner_ephemeral_disk
  }

  set {
    name = "githubWebhookServer.enabled"
    value = var.enable_github_webhook_server
    type = "auto"
  }

  set {
    name = "githubWebhookServer.service.type"
    value = "LoadBalancer"
  }

  set {
    name = "githubWebhookServer.service.annotations.cloud\\.google\\.com/load-balancer-type"
    value = "External"
  }

  set_sensitive {
    name = "githubWebhookServer.secret.github_webhook_secret_token"
    value = var.github_webhook_secret_token
  }

  depends_on = [helm_release.cert-manager]
}

resource "kubernetes_manifest" "runner-deployment" {
  manifest = {
    "apiVersion" = "actions.summerwind.dev/v1alpha1"
    "kind"       = "RunnerDeployment"
    "metadata" = {
      "name"      = "automati-runner"
      "namespace" = "actions-runner-system"
    }
    "spec" = {
      "template" = {
        "spec" = {
          "serviceAccountName" = "automati-k8s-sa"
          "repository" = "amocsub/automati"
          "labels" = ["automati"]
          "dockerEnabled" = false
          "resources" = {
            "requests" = {
              "cpu" = "${var.req_runner_cpu}"
              "memory" = "${var.req_runner_memory}"
              "ephemeral-storage" = "${var.req_runner_ephemeral_disk}"
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.actions-runner-controller-public]
}

resource "kubernetes_manifest" "horizontal-runner-autoscaler" {
  manifest = {
    "apiVersion" = "actions.summerwind.dev/v1alpha1"
    "kind" = "HorizontalRunnerAutoscaler"
    "metadata" = {
      "name" = "automati-autoscaler"
      "namespace" = "actions-runner-system"
    }
    "spec" = {
      "minReplicas" = var.min_replicas
      "maxReplicas" = var.max_replicas
      "scaleTargetRef" = {
        "kind" = "RunnerDeployment"
        "name" = "automati-runner"
      }
      "scaleUpTriggers" = [
        {
          "githubEvent" = {
            "workflowJob" = {}
          }
          "duration" = "${var.teardown_time}"
        }
      ]
    }
  }

  depends_on = [kubernetes_manifest.runner-deployment]
}
