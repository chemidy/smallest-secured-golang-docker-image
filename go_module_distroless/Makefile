VERSION=`git rev-parse HEAD`
BUILD=`date +%FT%T%z`
LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.Build=${BUILD}"

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

.PHONY: push-to-azure
push-to-azure:	## - Push docker image to azurecr.io container registry
	@az acr login --name chemidy
	@docker push chemidy.azurecr.io/smallest-secured-golang-docker-image:$(VERSION)

.PHONY: push-to-gcp
push-to-gcp:	## - Push docker image to gcr.io container registry
	@gcloud auth application-default login
	@gcloud auth configure-docker
	@docker push gcr.io/chemidy/smallest-secured-golang-docker-image:$(VERSION)
