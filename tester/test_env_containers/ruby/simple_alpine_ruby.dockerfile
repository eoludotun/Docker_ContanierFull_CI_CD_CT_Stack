FROM alpine:3.4

MAINTAINER Ben

RUN apk upgrade && \
    apk add --no-cache ruby ruby-bundler