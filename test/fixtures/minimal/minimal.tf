// Instantiate a minimal version of the module for testing

module "it_minimal" {
  source = "../../../" //minimal integration test

  logical_name = "${var.logical_name}"
  region       = "${var.region}"

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
