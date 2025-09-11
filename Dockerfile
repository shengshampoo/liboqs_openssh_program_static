FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required liboqs 
RUN apk add --no-cache \
  gcc make linux-headers musl-dev zlib-dev zlib-static \
  python3-dev libedit-dev libedit-static libedit \
  openssl-dev openssl-libs-static cmake git ninja \
  libtool autoconf automake bash

ENV XZ_OPT=-e9
COPY build-static-oqs-openssh.sh build-static-oqs-openssh.sh
RUN chmod +x ./build-static-oqs-openssh.sh
RUN bash ./build-static-oqs-openssh.sh  
