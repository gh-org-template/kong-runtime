ARG OSTYPE
ARG ARCHITECTURE
ARG DOCKER_REGISTRY=ghcr.io
ARG DOCKER_IMAGE_NAME
ARG DOCKER_ARCHITECTURE
ARG VERSION=1.3.11

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
