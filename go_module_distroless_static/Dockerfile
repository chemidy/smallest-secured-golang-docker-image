############################
# STEP 1 build executable binary
############################
# golang debian buster 1.14.1 linux/amd64
# https://github.com/docker-library/golang/blob/master/1.14/buster/Dockerfile
FROM golang@sha256:1e9c36b3fd7d7f9ab95835fb1ed898293ec0917e44c7e7d2766b4a2d9aa43da6 as builder

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
FROM gcr.io/distroless/static@sha256:c6d5981545ce1406d33e61434c61e9452dad93ecd8397c41e89036ef977a88f4

# Copy our static executable
COPY --from=builder /go/bin/hello /go/bin/hello

# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]
