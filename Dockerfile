# Simple usage with a mounted data directory:
# > docker build -t farmingapp .
#
# Server:
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.farmingapp:/root/.farmingapp farmingapp simd init test-chain
# TODO: need to set validator in genesis so start runs
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.farmingapp:/root/.farmingapp farmingapp simd start
#
# Client: (Note the farmingapp binary always looks at ~/.farmingapp we can bind to different local storage)
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.farmingappcli:/root/.farmingapp farmingapp simd keys add foo
# > docker run -it -p 26657:26657 -p 26656:26656 -v ~/.farmingappcli:/root/.farmingapp farmingapp simd keys list
# TODO: demo connecting rest-server (or is this in server now?)
FROM golang:alpine AS build-env

# Install minimum necessary dependencies,
ENV PACKAGES curl make git libc-dev bash gcc linux-headers eudev-dev python3
RUN apk add --no-cache $PACKAGES

# Set working directory for the build
WORKDIR /go/src/github.com/kogisin/cosmos-sdk-modules

# Add source files
COPY . .

# install farmingapp, remove packages
RUN make build-linux

# Final image
FROM alpine:edge

# Install ca-certificates
RUN apk add --update ca-certificates
WORKDIR /root

# Copy over binaries from the build-env
COPY --from=build-env /go/src/github.com/tendermint/farming/build/toyd /usr/bin/toyd

EXPOSE 26656 26657 1317 9090

# Run toyd by default
CMD ["toyd"]
