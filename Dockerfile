FROM archlinux/archlinux:latest
ARG BINARY_PATH
RUN pacman -Syu --noconfirm && pacman -S --noconfirm \
  ca-certificates \
  ghc-libs

RUN mkdir -p /opt/pms/
WORKDIR /opt/pms
COPY "$BINARY_PATH" /opt/pms

ENTRYPOINT ["/opt/pms/pms"]
