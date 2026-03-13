resource "kubernetes_namespace" "gitea" {
  metadata {
    name = "gitea"
  }
}

resource "kubernetes_deployment" "gitea" {
  metadata {
    name      = "gitea"
    namespace = kubernetes_namespace.gitea.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "gitea"
      }
    }

    template {
      metadata {
        labels = {
          app = "gitea"
        }
      }

      spec {
        container {
          name  = "gitea"
          image = "gitea/gitea:1.25"

          port {
            container_port = 3000
          }

          env {
            name  = "GITEA_database_DB_TYPE"
            value = "sqlite3"
          }

          env {
            name  = "GITEA_database_PATH"
            value = "/data/gitea/gitea.db"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "gitea" {
  metadata {
    name      = "gitea"
    namespace = kubernetes_namespace.gitea.metadata[0].name
  }

  spec {
    selector = {
      app = "gitea"
    }

    port {
      port        = 3000
      target_port = 3000
    }

    type = "NodePort"
  }
}