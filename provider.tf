terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.0"
    }
  }
}

provider "google" {
  project = "project-a1c51fe0-43ef-44f5-a46"
  region  = "asia-south1"
}