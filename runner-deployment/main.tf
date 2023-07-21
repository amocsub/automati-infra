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
          "repository"         = "${var.repository_name_with_owner}"
          "labels"             = ["automati"]
          "dockerEnabled"      = false
          "resources" = {
            "requests" = {
              "cpu"               = "${var.req_runner_cpu}"
              "memory"            = "${var.req_runner_memory}"
              "ephemeral-storage" = "${var.req_runner_ephemeral_disk}"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_manifest" "horizontal-runner-autoscaler" {
  manifest = {
    "apiVersion" = "actions.summerwind.dev/v1alpha1"
    "kind"       = "HorizontalRunnerAutoscaler"
    "metadata" = {
      "name"      = "automati-autoscaler"
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
