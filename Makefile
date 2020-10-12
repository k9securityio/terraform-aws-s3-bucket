.PHONY: deps format converge verify destroy shell test kitchen build circleci-build

IMAGE_NAME := qualimente/terraform-infra-dev
IMAGE_TAG := 0.12.29

FQ_IMAGE := $(IMAGE_NAME):$(IMAGE_TAG)

TERRAFORM_OPTS :=
terraform = @$(call execute,terraform $(1) $(TERRAFORM_OPTS))

terraform-docs = @$(call execute,terraform-docs $(1))

KITCHEN_OPTS :=
kitchen = @$(call execute,bundle exec kitchen $(1) $(KITCHEN_OPTS))

AWS_AUTH_VARS :=

ifdef AWS_PROFILE
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_PROFILE=$(AWS_PROFILE)
endif

ifdef AWS_ACCESS_KEY_ID
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_ACCESS_KEY_ID=$(AWS_ACCESS_KEY_ID)
endif

ifdef AWS_SECRET_ACCESS_KEY
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_SECRET_ACCESS_KEY=$(AWS_SECRET_ACCESS_KEY)
endif

ifdef AWS_SESSION_TOKEN
	AWS_AUTH_VARS += $(AWS_AUTH_VARS) -e AWS_SESSION_TOKEN=$(AWS_SESSION_TOKEN)
endif

AWS_OPTS := $(AWS_AUTH_VARS) -e AWS_REGION=$(AWS_REGION)

define execute
	if [ -z "$(CI)" ]; then \
		docker run --rm -it \
			$(AWS_OPTS) \
			-e USER=root \
			-v $(shell pwd):/module \
			-v $(HOME)/.aws:/root/.aws:ro \
			-v $(HOME)/.netrc:/root/.netrc:ro \
			$(FQ_IMAGE) \
			$(1); \
	else \
		echo $(1); \
		$(1); \
	fi;
endef

clean:
	rm -rf .terraform .kitchen terraform.tfstate.d test/fixtures/minimal/.terraform/ test/fixtures/minimal/generated/*

shell:
	@$(call execute,sh,)

deps:
	@set -e
	@if test -z $(CI); then \
		docker pull $(FQ_IMAGE); \
	fi;

init:
	@$(call kitchen,create)

format:
	@$(call terraform,fmt)

lint:
	@$(call terraform,get)

converge:
	@$(call kitchen,converge)

verify:
	@$(call kitchen,verify)

destroy:
	@$(call kitchen,destroy)

test:
	@$(call kitchen,test)

kitchen:
	@$(call kitchen,$(COMMAND))

docs:
	@$(call terraform-docs,markdown interface.tf > interface.md)
	@$(call terraform-docs,markdown k9policy/interface.tf > k9policy/interface.md)

all: deps init format converge verify docs

circleci-build:
	@circleci build \
	$(AWS_OPTS)
