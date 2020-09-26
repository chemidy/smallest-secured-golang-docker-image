# Create the smallest secured golang docker image based on scratch or distroless

Read the related article : [Create the smallest and secured golang docker image based on scratch or distroless](https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324)

```
✓ usage: make [target]

build-no-cache                 - Build the smallest and secured golang docker image based on scratch with no cache
build                          - Build the smallest and secured golang docker image based on scratch
help                           - Show help message
ls                             - List 'smallest-secured-golang' docker images
push-to-azure                  - Push docker image to azurecr.io container registry
push-to-gcp                    - Push docker image to gcr.io container registry
run                            - Run the smallest and secured golang docker image based on scratch
scan                           - Scan for known vulnerabilities the smallest and secured golang docker image based on scratch
```

# Quickstart 

```
make build && make run
```
