FROM archlinux:latest
RUN mkdir -p /opt/pms/
ARG BINARY_PATH
WORKDIR /opt/pms
RUN pacman -Syu --noconfirm && pacman -S --noconfirm \
  ca-certificates
COPY "$BINARY_PATH" /opt/pms

CMD ["/opt/pms/pms"]
