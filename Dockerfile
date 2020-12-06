FROM archlinux:latest
RUN mkdir -p /opt/pms/
ARG BINARY_PATH
WORKDIR /opt/pms
RUN pacman -Syu --noconfirm && pacman -S --noconfirm \
  ca-certificates
COPY "$BINARY_PATH" /opt/pms

ENV APP_PORT=8080
ENV SMTP_HOST=smtp.gmail.com
ENV SMTP_USER=john.doe
ENV SMTP_PW=secret
ENV SMTP_PORT=465
ENV MAIL_SENDER=asdf@example.com
ENV MAIL_RECIPIENT=asdf@example.com

CMD ["/opt/pms/pms"]
