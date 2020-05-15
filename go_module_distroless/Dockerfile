############################
# STEP 1 build executable binary
############################
# golang debian buster 1.14 linux/amd64
# https://github.com/docker-library/golang/blob/master/1.14/buster/Dockerfile
FROM golang@sha256:eee8c0a92bc950ecb20d2dffe46546da12147e3146f1b4ed55072c10cacf4f4c as builder

# Ensure ca-certficates are up to date
RUN update-ca-certificates

WORKDIR $GOPATH/src/mypackage/myapp/

# use modules
COPY go.mod .

ENV GO111MODULE=on
RUN go mod tidy
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
FROM gcr.io/distroless/base@sha256:2b0a8e9a13dcc168b126778d9e947a7081b4d2ee1ee122830d835f176d0e2a70

# Copy our static executable
COPY --from=builder /go/bin/hello /go/bin/hello

# Run the hello binary.
ENTRYPOINT ["/go/bin/hello"]
