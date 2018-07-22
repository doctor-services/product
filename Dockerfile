FROM golang:alpine

RUN apk add --no-cache bash
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN mkdir -p /go/bin && chown $USER:$USER /go/bin

COPY ./build/product-server /go/bin/product-server
RUN chmod +x /go/bin/product-server

# Expose the server TCP port
EXPOSE 80
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/go/bin/product-server"]
