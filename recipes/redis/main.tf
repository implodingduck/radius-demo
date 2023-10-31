resource "kubernetes_deployment" "redis" {
  metadata {
    name = "redis-${sha512(var.recipe_context.resource.id)}"
    namespace = var.recipe_context.runtime.kubernetes.namespace
    labels = {
      app = "redis"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "redis"
        resource = var.recipe_context.resource.name
      }
    }
    template {
      metadata {
        labels = {
          app = "redis"
          resource = var.recipe_context.resource.name
        }
      }
      spec {
        container {
          name  = "redis"
          image = "redis:6" 
          port {
            container_port = 6379
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "redis" {
  metadata {
    name = "redis-${sha512(var.recipe_context.resource.id)}"
    namespace = var.recipe_context.runtime.kubernetes.namespace
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "redis"
      resource = var.recipe_context.resource.name
    }
    port {
      port        = var.port
      target_port = "6379"
    }
  }
}
