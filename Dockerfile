# build static plexdrive binary from source
FROM golang:1.19-bullseye AS build-plexdrive
WORKDIR /build
RUN git clone --single-branch https://github.com/plexdrive/plexdrive /build \
  && CGO_ENABLED=0 go build \
    -ldflags "-X main.Version=$(git describe --tags) -extldflags '-static' -s -w" \
    -tags netgo \
    -trimpath

# install fusermount binary from apt
FROM debian:bullseye AS install-fusermount
RUN apt-get update \
  && apt-get install --no-install-recommends --yes fuse3 \
  && rm -rf /var/lib/apt/lists/*

# prepare root layer
FROM scratch AS prepare-root
COPY root /root
COPY --from=build-plexdrive /build/plexdrive /root/usr/local/bin/plexdrive
COPY --from=install-fusermount /bin/fusermount /root/usr/local/bin/fusermount

# final single layer image
FROM scratch
COPY --from=prepare-root /root /
