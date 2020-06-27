FROM alpine:3.12.0 AS build

ARG VERSION=zopfli-1.0.3

WORKDIR /build

RUN apk add --no-cache build-base git \
    && git clone https://github.com/google/zopfli.git . && git checkout ${VERSION}

RUN make zopflipng

FROM scratch
COPY --from=build /build/zopflipng /usr/local/bin/zopflipng
COPY --from=build /lib/ld-musl-x86_64.so.1 /lib/ld-musl-x86_64.so.1
COPY --from=build /usr/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6
COPY --from=build /usr/lib/libgcc_s.so.1 /usr/lib/libgcc_s.so.1

WORKDIR /data
ENTRYPOINT ["/usr/local/bin/zopflipng"]
CMD []