# Use official multi-arch Go image
FROM golang:1.23.4 AS build

# Install build dependencies
RUN apt-get update && apt-get install -y git build-essential libsecret-1-dev

# Build ProtonMail Bridge
WORKDIR /build/
COPY build.sh VERSION /build/
RUN bash build.sh

# Use Debian-based image for better package support
FROM debian:bookworm
LABEL maintainer="Xiaonan Shen <s@sxn.dev>"

EXPOSE 25/tcp
EXPOSE 143/tcp
EXPOSE 1025/tcp
EXPOSE 1143/tcp

# Install necessary system tools
RUN apt-get update && apt-get install -y \
    net-tools \
    procps \
    iproute2 \
    netcat-openbsd \
    curl \
    wget \
    dnsutils \
    socat \
    libsecret-1-0 \
    ca-certificates \ 
    libglib2.0-0 \
    libgtk-3-0 \
    libsoup2.4-1 \
    libgdk-pixbuf-2.0-0 \
    libjson-glib-1.0-0 \
    libsqlite3-0 \
    libnss3 \
    pass \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Copy entrypoint script and ProtonMail Bridge binaries
COPY gpgparams entrypoint.sh /protonmail/
COPY --from=build /build/proton-bridge/bridge /protonmail/
COPY --from=build /build/proton-bridge/proton-bridge /protonmail/

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
