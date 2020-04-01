terraform {
  backend "gcs" {
    bucket = "storage-bucket-ikv"
    prefix = "global/stage"
  }
}
