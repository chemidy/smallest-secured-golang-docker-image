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

# Build the binary
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-w -s" -a -installsuffix cgo -o /go/bin/hello .

############################
# STEP 2 build a small image
############################
# using base nonroot image
# user:group is nobody:nobody, uid:gid = 65534:65534
FROM gcr.io/distroless/base@sha256:be73c7e6bb15793be42cdba97ca55d731558d8a625acdc13f9b8d49e3ef7de02

# Copy our static executable
COPY --from=builder /go/bin/hello /go/bin/hello

# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]
