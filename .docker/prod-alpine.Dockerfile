ARG VERSION=latest-alpine3.20

FROM alpine:3.20 AS build
COPY . /source
RUN sh /source/.github/install-openvas-smb-dependencies-alpine.sh
 
WORKDIR /source
RUN cp .github/alpine-patches/*.patch . && git apply *.patch

RUN cmake -DCMAKE_BUILD_TYPE=Release -B/build /source
RUN DESTDIR=/install cmake --build /build -- install

FROM alpine:3.20

RUN apk update && apk upgrade && \
  apk add --no-cache gnutls \
  heimdal \
  popt

COPY --from=build /install/ /

