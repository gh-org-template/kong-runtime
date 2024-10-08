ARG OSTYPE=linux-gnu
ARG ARCHITECTURE=amd64
ARG DOCKER_REGISTRY=ghcr.io
ARG DOCKER_ARCHITECTURE=amd64
ARG VERSION=1.1.1o

FROM --platform=linux/${DOCKER_ARCHITECTURE} ghcr.io/gh-org-template/kong-openssl:${VERSION}-${OSTYPE} AS build

COPY . /tmp
WORKDIR /tmp

# Run our predecessor tests
# Configure, build, and install
# Run our own tests
# Re-run our predecessor tests
ENV DEBUG=0
RUN /test/*/test.sh && \
    /tmp/build.sh && \
    /tmp/test.sh && \
    /test/*/test.sh

# Test scripts left where downstream images can run them
COPY test.sh /test/kong-runtime/test.sh
COPY .env /test/kong-runtime/.env

# Copy the build result to scratch so we can export the result
FROM scratch AS package

COPY --from=build /tmp/build /
