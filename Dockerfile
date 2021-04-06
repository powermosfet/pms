FROM alpine:latest
ARG BINARY_PATH
RUN apk add ca-certificates

RUN mkdir -p /opt/pms/
WORKDIR /opt/pms
COPY "$BINARY_PATH" /opt/pms
RUN chmod a+x /opt/pms/pms

CMD ["/opt/pms/pms"]
