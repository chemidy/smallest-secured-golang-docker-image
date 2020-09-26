# Create the smallest secured golang docker image based on distroless

Read the related article : [Create the smallest and secured golang docker image based on scratch](https://medium.com/@chemidy/create-the-smallest-and-secured-golang-docker-image-based-on-scratch-4752223b7324)

```
✓ usage: make [target]

build-no-cache                 - Build the smallest and secured golang docker image based on distroless with no cache
build                          - Build the smallest and secured golang docker image based on distroless
help                           - Show help message
ls                             - List 'smallest-secured-golang' docker images
push-to-azure                  - Push docker image to azurecr.io container registry
push-to-gcp                    - Push docker image to gcr.io container registry
run                            - Run the smallest and secured golang docker image based on distroless
scan                           - Scan for known vulnerabilities the smallest and secured golang docker image based on distroless
```

# Quickstart 

```
make build && make run
```
