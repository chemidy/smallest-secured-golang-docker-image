VERSION=`git rev-parse HEAD`
BUILD=`date +%FT%T%z`
LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}"
DOCKER_IMAGE=smallest-secured-golang-docker-image

# AWS related variables, eu-west-3 is Paris region
AWS_REGION=eu-west-3
AWS_ACCOUNT_NUMBER=123412341234

#GCP related variables
GCP_PROJECT_ID='chemidy'

.PHONY: help
help: ## - Show help message
	@printf "\033[32m\xE2\x9c\x93 usage: make [target]\n\n\033[0m"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: docker-pull
docker-pull:	## - docker pull latest images
	@printf "\033[32m\xE2\x9c\x93 docker pull latest images\n\033[0m"
	@docker pull golang:alpine

.PHONY: docker-pull-distroless
docker-pull-distroless:	## - docker pull latest images
	@printf "\033[32m\xE2\x9c\x93 docker pull latest images\n\033[0m"
	@docker pull golang:buster
	@docker pull gcr.io/distroless/base
	@docker pull gcr.io/distroless/static

.PHONY: build
build:docker-pull	## - Build the smallest and secured golang docker image based on scratch
	@printf "\033[32m\xE2\x9c\x93 Build the smallest and secured golang docker image based on scratch\n\033[0m"
	$(eval BUILDER_IMAGE=$(shell docker inspect --format='{{index .RepoDigests 0}}' golang:alpine))
	@export DOCKER_CONTENT_TRUST=1
	@docker build -f docker/scratch.Dockerfile --build-arg "BUILDER_IMAGE=$(BUILDER_IMAGE)" -t smallest-secured-golang .

.PHONY: build-module
build-module:docker-pull	## - Build the smallest and secured golang docker image based on scratch
	@printf "\033[32m\xE2\x9c\x93 Build the smallest and secured golang docker image based on scratch\n\033[0m"
	$(eval BUILDER_IMAGE=$(shell docker inspect --format='{{index .RepoDigests 0}}' golang:alpine))
	@export DOCKER_CONTENT_TRUST=1
	@docker build -f docker/scratch_module.Dockerfile --build-arg "BUILDER_IMAGE=$(BUILDER_IMAGE)" -t smallest-secured-golang .

.PHONY: build-distroless
build-distroless:docker-pull-distroless	## - Build the smallest and secured golang docker image based on distroless
	@printf "\033[32m\xE2\x9c\x93 Build the smallest and secured golang docker image based on distroless\n\033[0m"
	$(eval BUILDER_IMAGE=$(shell docker inspect --format='{{index .RepoDigests 0}}' golang:buster))
	$(eval DISTROLESS_IMAGE=$(shell docker inspect --format='{{index .RepoDigests 0}}' gcr.io/distroless/base))
	@export DOCKER_CONTENT_TRUST=1
	@docker build -f docker/distroless.Dockerfile --build-arg BUILDER_IMAGE=$(BUILDER_IMAGE) --build-arg DISTROLESS_IMAGE=$(DISTROLESS_IMAGE) -t smallest-secured-golang-distroless .

.PHONY: build-distroless-static
build-distroless-static:docker-pull-distroless	## - Build the smallest and secured golang docker image based on distroless static
	@printf "\033[32m\xE2\x9c\x93 Build the smallest and secured golang docker image based on distroless static\n\033[0m"
	$(eval BUILDER_IMAGE=$(shell docker inspect --format='{{index .RepoDigests 0}}' golang:buster))
	$(eval DISTROLESS_IMAGE=$(shell docker inspect --format='{{index .RepoDigests 0}}' gcr.io/distroless/static))
	@export DOCKER_CONTENT_TRUST=1
	@docker build -f docker/distroless_static.Dockerfile --build-arg BUILDER_IMAGE=$(BUILDER_IMAGE) --build-arg DISTROLESS_IMAGE=$(DISTROLESS_IMAGE) -t smallest-secured-golang-distroless-static .

.PHONY: build-no-cache
build-no-cache:docker-pull	## - Build the smallest and secured golang docker image based on scratch with no cache
	@printf "\033[32m\xE2\x9c\x93 Build the smallest and secured golang docker image based on scratch\n\033[0m"
	$(eval BUILDER_IMAGE=$(shell docker inspect --format='{{index .RepoDigests 0}}' golang:alpine))
	@export DOCKER_CONTENT_TRUST=1
	@docker build --no-cache -f docker/scratch.Dockerfile --build-arg "BUILDER_IMAGE=$(BUILDER_IMAGE)" -t smallest-secured-golang .

.PHONY: ls
ls: ## - List 'smallest-secured-golang' docker images
	@printf "\033[32m\xE2\x9c\x93 Look at the size dude !\n\033[0m"
	@docker image ls smallest-secured-golang

.PHONY: run
run:	## - Run the smallest and secured golang docker image based on scratch
	@printf "\033[32m\xE2\x9c\x93 Run the smallest and secured golang docker image based on scratch\n\033[0m"
	@docker run smallest-secured-golang:latest

.PHONY: push-to-aws
push-to-aws:	## - Push docker image to AWS Elastic Container Registry
	@aws ecr get-login-password --region $(AWS_REGION) | docker login --username AWS --password-stdin $(AWS_ACCOUNT_NUMBER).dkr.ecr.$(AWS_REGION).amazonaws.com
	@docker tag smallest-secured-golang:latest $(AWS_ACCOUNT_NUMBER).dkr.ecr.$(AWS_REGION).amazonaws.com/$(DOCKER_IMAGE):$(VERSION)
	@docker push $(AWS_ACCOUNT_NUMBER).dkr.ecr.$(AWS_REGION).amazonaws.com/$(DOCKER_IMAGE):$(VERSION)

.PHONY: push-to-azure
push-to-azure:	## - Push docker image to azurecr.io Container Registry
	@az acr login --name chemidy
	@docker push chemidy.azurecr.io/$(DOCKER_IMAGE):$(VERSION)

.PHONY: push-to-gcp
push-to-gcp:	## - Push docker image to gcr.io Container Registry
	@gcloud config set project $(GCP_PROJECT_ID)
	@gcloud auth application-default login
	@gcloud auth configure-docker
	@docker --tag smallest-secured-golang:latest gcr.io/$(GCP_PROJECT_ID)/$(DOCKER_IMAGE):$(VERSION)
	@docker push gcr.io/$(GCP_PROJECT_ID)/$(DOCKER_IMAGE):$(VERSION)

.PHONY: deploy-to-gcp
deploy-to-gcp:	## - deploy docker image to gcp cloud run
	@gcloud --project=$(GCP_PROJECT_ID) run deploy smallest-secured-golang \
	--image=gcr.io/$(GCP_PROJECT_ID)/$(DOCKER_IMAGE):$(VERSION) \
	--allow-unauthenticated \
	--max-instances=10 \
	--platform=managed \
	--region=europe-west1 \

.PHONY: scan
scan:	## - Scan for known vulnerabilities the smallest and secured golang docker image based on scratch
	@printf "\033[32m\xE2\x9c\x93 Scan for known vulnerabilities the smallest and secured golang docker image based on scratch\n\033[0m"
	@docker scan -f Dockerfile smallest-secured-golang
