############################
# STEP 1 build executable binary
############################
# golang debian buster 1.15 linux/amd64
# https://github.com/docker-library/golang/blob/master/1.15/buster/Dockerfile
FROM golang@sha256:32e45459a1e22262d9a307074c1a796a86f5c08c85dcde5bfbbf9e7c411eb990 as builder

# Ensure ca-certficates are up to date
RUN update-ca-certificates

WORKDIR $GOPATH/src/mypackage/myapp/

# use modules
COPY go.mod .

ENV GO111MODULE=on
RUN go mod download
RUN go mod verify

COPY . .

# Build the static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
      -ldflags='-w -s -extldflags "-static"' -a \
      -o /go/bin/hello .

############################
# STEP 2 build a small image
############################
# using static nonroot image
# user:group is nobody:nobody, uid:gid = 65534:65534
FROM gcr.io/distroless/static@sha256:08cce4d65b19780e10b555578a0f9c9af51310308ec31e648577122d40e6922a

# Copy our static executable
COPY --from=builder /go/bin/hello /go/bin/hello

# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]
