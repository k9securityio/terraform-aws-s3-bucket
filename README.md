# Terraform S3 bucket and policy module #

k9 Security's tf_s3_bucket helps you protect your data by creating an s3 bucket with safe defaults and a 
least-privilege bucket policy built on the 
[k9 access capability model](https://k9security.io/docs/k9-access-capability-model/).

Specify context about your use case, including intended access the module and will:

* create a bucket named using your context
* generate a least privilege bucket policy
* configure encryption
* apply appropriate tags
* configure access logging
* and more

[![CircleCI](https://circleci.com/gh/k9securityio/tf_s3_bucket.svg?style=svg)](https://circleci.com/gh/k9securityio/tf_s3_bucket)

## Usage
The root of this repository contains a Terraform module that manages an AWS S3 bucket.

A simple instantiation of that module like this:
```hcl-terraform
module "s3_bucket" {
  source = "git@github.com:k9securityio/tf_s3_bucket.git"
  
  # the logical name for the use case, e.g. docs, reports, media, backups 
  logical_name = "docs"
  # the region to create the bucket in
  region       = "us-east-1"

  logging_target_bucket = "name of the bucket to log to, e.g. my-logs-bucket"

  org   = "someorg"
  owner = "someowner"
  env   = "dev"
  app   = "someapi"

  policy = "${module.least_privilege_bucket_policy.policy_json}"
}
```

That module instantiation should look straightforward except for perhaps the policy attribute.

This s3 bucket module accepts a bucket policy.  You can generate a least privilege bucket policy using the 
policy submodule.

First, define who will have access to the bucket as lists of AWS principal ARNS: 
```hcl-terraform
# Define which principals may access the bucket and what capabilities they have
# The access capabilities are defined at https://k9security.io/docs/k9-access-capability-model/  
locals {
  administrator_arns = [
    "arn:aws:iam::12345678910:user/ci"
    , "arn:aws:iam::12345678910:user/person1"
  ]

  read_data_arns = [
    "arn:aws:iam::12345678910:user/person1",
    "arn:aws:iam::12345678910:role/appA",
  ]

  write_data_arns = "${local.read_data_arns}"
}
```

Then, instantiate the `k9policy` module:

```hcl-terraform
module "least_privilege_bucket_policy" {
  source        = "git@github.com:k9securityio/tf_s3_bucket.git//k9policy"
  s3_bucket_arn = "${module.s3_bucket.bucket_arn}"

  allow_administer_resource_arns = "${local.administrator_arns}"
  allow_read_data_arns           = "${local.read_data_arns}"
  allow_write_data               = "${local.write_data_arns}"
  # unused: allow_delete_data          = [] (default)
  # unused: allow_use_resource         = [] (default)
}
```

This code enables the following access:

* allow `ci` and `person1` users to administer the bucket
* allow `person1` user and `appA` role to read and write data from the bucket
* deny all other access; this is the tricky bit! 

See the 'minimal' test fixture at [test/fixtures/minimal/minimal.tf](test/fixtures/minimal/minimal.tf) for complete 
examples of how to use these S3 bucket and policy modules.  

## Local Development and Testing

Testing modules locally can be accomplished using a series of `Make` tasks
contained in this repo.

| Make Task | What happens                                                                                                  |
|:----------|:--------------------------------------------------------------------------------------------------------------|
| all       | Execute the canonical build for the generic infrastructure module (does not destroy infra)                    |
| converge  | Execute `kitchen converge` for all modules                                                                    |
| circleci-build  | Run a local circleci build                                                                              |
| lint      | Execute `tflint` for generic infrastructure module                                                            |
| test      | Execute `kitchen test --destroy=always` for all modules                                                       |
| verify    | Execute `kitchen verify` for all modules                                                                      |
| destroy   | Execute `kitchen destroy` for all modules                                                                     |
| kitchen   | Execute `kitchen <command>`. Specify the command with the `COMMAND` argument to `make`                        |

e.g. run a single test: `make kitchen COMMAND="verify minimal-aws"`

**Typical Workflow:**

1. Start-off with a clean slate of running test infrastructure: `make destroy; make all`
2. Make changes and (repeatedly) run: `make converge && make verify`
3. Rebuild everything from scratch: `make destroy; make all`
4. Commit and issue pull request


## Running Test Kitchen for a single module

Test Kitchen uses the concept of "instances" as it's medium for multiple test 
packages in a project.
An "instance" is the combination of a _test suite_ and a _platform_.
This project uses a single _platform_ for all specs (e.g. `aws`).
The name of this platform actually doesn't matter since the terraform provisioner
and driver are not affected by it.

You can see the available test instances by running the `kitchen list` command:

```bash
$ make kitchen COMMAND=list
Instance     Driver     Provisioner  Verifier   Transport  Last Action  Last Error
default-aws  Terraform  Terraform    Terraform  Ssh        Verified
```

To run Test Kitchen processes for a single instance, you **must** use the `kitchen`
target from the make file and pass the command and the instance name using the
`COMMAND` variable to make.

```bash
# where 'default-aws is an Instance name from kitchen's list
$ make kitchen COMMAND="converge default-aws"
```