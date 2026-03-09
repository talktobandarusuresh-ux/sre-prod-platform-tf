locals {

  project = "sre-platform"

  tags = {

    Project = "SREPlatform"

    Environment = var.environment
  }
}