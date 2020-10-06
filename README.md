# Create the smallest secured golang docker image based on scratch or distroless

Read the related article : [Create the smallest and secured golang docker image based on scratch or distroless](https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324)

```
✓ usage: make [target]

build-distroless-static        - Build the smallest and secured golang docker image based on distroless static
build-distroless               - Build the smallest and secured golang docker image based on distroless
build-module                   - Build the smallest and secured golang docker image based on scratch
build-no-cache                 - Build the smallest and secured golang docker image based on scratch with no cache
build                          - Build the smallest and secured golang docker image based on scratch
deploy-to-gcp                  - deploy docker image to gcp cloud run
docker-pull                    - docker pull latest images
help                           - Show help message
ls                             - List 'smallest-secured-golang' docker images
push-to-aws                    - Push docker image to AWS Elastic Container Registry
push-to-azure                  - Push docker image to azurecr.io Container Registry
push-to-gcp                    - Push docker image to gcr.io Container Registry
run                            - Run the smallest and secured golang docker image based on scratch
scan                           - Scan for known vulnerabilities the smallest and secured golang docker image based on scratch
```

# Quickstart 

```
make build && make run
```

# Pushing to AWS Elastic Container Registry 

One of AWS ECR pain points is that you can only have one image per repository.
However, each repository can have multiple versions of the same image.
You will first need to create the repository in ECR, either from the console or from the command line.

The commands in the makefile assumes you have AWS cli properly configured.
Either by having the following environment variables defined: AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY.
Or by having run the _aws configure_ command beforehand.

Two variables have a default value assigned: AWS_REGION and AWS_ACCOUNT_NUMBER.
The AWS_ACCOUNT_NUMBER is a 12-digit number.
Please see the [official documentation](https://docs.aws.amazon.com/general/latest/gr/acct-identifiers.html) if you need to find out your account number.
