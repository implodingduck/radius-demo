variable "context" {
  type = any
  default = {
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

variable "port" {
  description = "The port Redis is offered on. Defaults to 6379."
  type = number
  default = 6379
}