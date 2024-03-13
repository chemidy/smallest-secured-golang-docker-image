ARG BUILDER_IMAGE=golang:1.22-alpine
ARG DISTROLESS_IMAGE=gcr.io/distroless/static

############################
# STEP 1 build executable binary
############################
FROM ${BUILDER_IMAGE} as builder

# Ensure ca-certficates are up to date
RUN update-ca-certificates

# Set the working directory to the root of your Go module
WORKDIR /myapp

# Add cache for faster builds
ENV GOCACHE=$HOME/.cache/go-build
RUN --mount=type=cache,target=$GOCACHE

# Use modules
COPY go.mod .
RUN go mod download && go mod verify

# Copy the source code and build the static binary
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags='-w -s -extldflags "-static"' -a \
    -o /myapp/hello .

############################
# STEP 2 build a small image
############################
# using static nonroot image
# user:group is nobody:nobody, uid:gid = 65534:65534
FROM ${DISTROLESS_IMAGE}

# Copy our static executable
COPY --from=builder /myapp/hello /myapp/hello

# Run the hello binary.
ENTRYPOINT ["/myapp/hello"]
