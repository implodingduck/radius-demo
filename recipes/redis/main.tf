locals {
  recipe_context = {
    resource = {
        id = "1234-5678-9012-3456"
        name = "hardcoded"
    }
    runtime = {
        kubernetes = {
            namespace = "default"
        }
    }
  }
}

resource "kubernetes_deployment" "redis" {
  metadata {
    name = "redis-${sha512(local.recipe_context.resource.id)}"
    namespace = local.recipe_context.runtime.kubernetes.namespace
    labels = {
      app = "redis"
    }
  }
  spec {
    selector {
      match_labels = {
        app = "redis"
        resource = local.recipe_context.resource.name
      }
    }
    template {
      metadata {
        labels = {
          app = "redis"
          resource = local.recipe_context.resource.name
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
    name = "redis-${sha512(local.recipe_context.resource.id)}"
    namespace = local.recipe_context.runtime.kubernetes.namespace
  }
  spec {
    type = "ClusterIP"
    selector = {
      app = "redis"
      resource = local.recipe_context.resource.name
    }
    port {
      port        = var.port
      target_port = "6379"
    }
  }
}
