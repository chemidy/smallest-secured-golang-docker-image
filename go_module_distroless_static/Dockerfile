############################
# STEP 1 build executable binary
############################
# golang debian buster 1.13.6 linux/amd64
# https://github.com/docker-library/golang/blob/master/1.13/buster/Dockerfile
FROM golang@sha256:93a56423351235e070b3630e0a8b3e27d5e868883d4dff591f676315f208a574 as builder

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
FROM gcr.io/distroless/static@sha256:08322afd57db6c2fd7a4264bf0edd9913176835585493144ee9ffe0c8b576a76

# Copy our static executable
COPY --from=builder /go/bin/hello /go/bin/hello

# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]
