############################
# STEP 1 build executable binary
############################
# golang debian buster 1.15 linux/amd64
# https://github.com/docker-library/golang/blob/master/1.15/buster/Dockerfile
FROM golang@sha256:29452ef08bd0535f550c47b6034522c82ac10517b49c5f3b7a00035ecee0089e as builder

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
FROM gcr.io/distroless/static@sha256:7d687a1d8809b89c60211ff08a9277ffbe76895907aedffac4d2400a4e1a2dc7

# Copy our static executable
COPY --from=builder /go/bin/hello /go/bin/hello

# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]
