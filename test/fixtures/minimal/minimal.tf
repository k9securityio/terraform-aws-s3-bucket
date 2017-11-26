// Instantiate a minimal version of the module for testing
provider "aws" {
  region = "us-east-1"
}

resource "random_id" "testing_suffix" {
  byte_length = 4
}

//Create a logging bucket specifically for this test to support shipping of the access logs produced by the it_minimal bucket
resource "aws_s3_bucket" "log_bucket" {
  bucket = "qm-test-log-${random_id.testing_suffix.hex}"
  acl    = "log-delivery-write"
}

module "it_minimal" {
  source = "../../../" //minimal integration test

  logical_name = "${var.logical_name}-${random_id.testing_suffix.hex}"
  region       = "${var.region}"

  logging_target_bucket = "${aws_s3_bucket.log_bucket.id}"

  org   = "${var.org}"
  owner = "${var.owner}"
  env   = "${var.env}"
  app   = "${var.app}"
}

variable "logical_name" {
  type = "string"
}

variable "region" {
  type = "string"
}

variable "org" {
  type = "string"
}

variable "owner" {
  type = "string"
}

variable "env" {
  type = "string"
}

variable "app" {
  type = "string"
}
