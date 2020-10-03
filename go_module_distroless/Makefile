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

.PHONY: build
build:	## - Build the smallest and secured golang docker image based on distroless
	@printf "\033[32m\xE2\x9c\x93 Build the smallest and secured golang docker image based on distroless\n\033[0m"
	@export DOCKER_CONTENT_TRUST=1 && docker build -f Dockerfile -t smallest-secured-golang-distroless .

.PHONY: build-no-cache
build-no-cache:	## - Build the smallest and secured golang docker image based on scratch with no cache
	@printf "\033[32m\xE2\x9c\x93 Build the smallest and secured golang docker image based on scratch\n\033[0m"
	@export DOCKER_CONTENT_TRUST=1 && docker build --no-cache -f Dockerfile -t smallest-secured-golang-distroless .

.PHONY: ls
ls: ## - List 'smallest-secured-golang' docker images
	@printf "\033[32m\xE2\x9c\x93 Look at the size dude !\n\033[0m"
	@docker image ls smallest-secured-golang-distroless

.PHONY: run
run:	## - Run the smallest and secured golang docker image based on distroless
	@printf "\033[32m\xE2\x9c\x93 Run the smallest and secured golang docker image based on scratch\n\033[0m"
	@docker run smallest-secured-golang-distroless:latest

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
scan:	## - Scan for known vulnerabilities the smallest and secured golang docker image based on distroless
	@printf "\033[32m\xE2\x9c\x93 Scan for known vulnerabilities the smallest and secured golang docker image based on distroless\n\033[0m"
	@docker scan -f Dockerfile smallest-secured-golang-distroless
