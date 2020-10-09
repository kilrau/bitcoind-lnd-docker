# Build image
FROM golang:1.13-alpine3.10 as builder
# Add build tools.
RUN apk --no-cache --virtual build-dependencies add \
  build-base \
  git
# Grab and install the latest version of lnd
RUN git clone https://github.com/lightningnetwork/lnd $GOPATH/src/github.com/lightningnetwork/lnd
WORKDIR $GOPATH/src/github.com/lightningnetwork/lnd
RUN git reset --hard v0.11.1-beta
RUN make install tags="autopilotrpc chainrpc experimental invoicesrpc routerrpc signrpc walletrpc watchtowerrpc wtclientrpc"

# Final image
FROM alpine:3.12 as final
RUN apk add --no-cache bash expect supervisor tor
COPY --from=builder /go/bin/lnd /go/bin/lncli /usr/local/bin/
COPY entrypoint.sh start_tor.sh wait-file.sh /
COPY supervisord.conf /etc/supervisor/conf.d/
COPY torrc /etc/tor/
VOLUME [ "/root/.lnd" ]
RUN mkdir -p /root/.lnd/tor
ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
