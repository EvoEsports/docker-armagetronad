# build zthread
FROM alpine:3.18 as build-zthread
WORKDIR /build
ADD zthread.patch /build
RUN true \
    && set -eux \
    && apk upgrade \
    && apk add alpine-sdk wget \
    && wget -q http://prdownloads.sourceforge.net/zthread/ZThread-2.3.2.tar.gz \
    && tar xfvz ZThread-2.3.2.tar.gz \
    && cd ZThread-2.3.2 \
    && for f in config.guess config.sub; do \
		curl -fsSL -o "$f" "https://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=$f;hb=HEAD"; \
	done \
    && patch -p1 < /build/zthread.patch \
    && mkdir /build/usr \
    && CXXFLAGS="-fpermissive" ./configure --prefix=/build/usr \
    && make -j$((`nproc`+1)) && make install \
    && true

# build armagetronad
FROM alpine:3.18 as build-armagetronad
WORKDIR /build
COPY --from=build-zthread --chmod=0755 "/build/usr/bin/zthread-config" "/usr/lib/bin/"
COPY --from=build-zthread --chmod=0755 "/build/usr/include/zthread" "/usr/include/"
COPY --from=build-zthread --chmod=0755 "/build/usr/lib/libZThread-2.3.so.2" "/usr/lib/"
RUN true \
    && set -eux \
    && apk upgrade \
    && apk add alpine-sdk autoconf automake bash bison boost-dev libxml2-dev pkgconf protobuf-c-compiler \
    && wget -q -O "armagetronad.tar.gz" "https://bazaar.launchpad.net/~armagetronad-ap/armagetronad/0.2.9-armagetronad-sty+ct+ap/tarball" \
    && tar xfvz armagetronad.tar.gz --strip=2 \
    && cd 0.2.9-armagetronad-sty+ct+ap \
    && ./bootstrap.sh \
    && mkdir /build/armagetronad \
    && CXXFLAGS="-pipe" ./configure --disable-glout --enable-dedicated --enable-master --enable-authentication --enable-armathentication --enable-krawall --enable-music --disable-automakedefaults --disable-sysinstall --disable-useradd --disable-etc --disable-desktop --disable-initscripts --disable-uninstall --disable-games --with-zthread --prefix=/build/armagetronad --exec_prefix=/build/armagetronad \
    && make -j$((`nproc`+1)) && make install \
    && rm -Rf /build/armagetronad/share/armagetronad-dedicated/desktop \
    && rm -Rf /build/armagetronad/share/armagetronad-dedicated/scripts \
    && true

# create image
FROM alpine:3.18 as create-image

ARG BUILD_DATE \
    REVISION \
    VERSION

LABEL org.opencontainers.image.title="Armagetron Advanced Server" \
      org.opencontainers.image.description="Server docker image for the open source game Armagetron Advanced." \
      org.opencontainers.image.version=${VERSION} \
      org.opencontainers.image.created=${BUILD_DATE} \
      org.opencontainers.image.revision=${REVISION} \
      org.opencontainers.image.authors="Nicolas Graf <nicolas.graf@evoesports.gg>" \
      org.opencontainers.image.vendor="Evo eSports e.V." \
      org.opencontainers.image.licenses="Apache-2.0"

WORKDIR /armagetron

RUN true \
    && set -eux \
    && addgroup -g 9999 armagetron \
    && adduser -u 9999 -Hh /armagetron -G armagetron -s /sbin/nologin -D armagetron \
    && install -d -o armagetron -g armagetron -m 775 /armagetron \
    && apk add --force-overwrite --no-cache libstdc++ libxml2 \
    && mkdir ./data ./userdata ./config ./userconfig ./resource ./autoresource ./var \
    && chown armagetron:armagetron -Rf /armagetron \
    && true

COPY --from=build-zthread --chmod=0755 "/build/usr/lib/libZThread-2.3.so.2" "/usr/lib/"
COPY --from=build-armagetronad --chmod=0755 "/build/armagetronad/bin" "/usr/local/bin"
COPY --from=build-armagetronad --chown=armagetron:armagetron --chmod=0755 "/build/armagetronad/etc/armagetronad-dedicated" "./config"
COPY --from=build-armagetronad --chown=armagetron:armagetron --chmod=0755 "/build/armagetronad/share/armagetronad-dedicated" "./data"
COPY --chmod=0755 "entrypoint.sh" "/usr/local/bin/"

USER armagetron

STOPSIGNAL SIGKILL

EXPOSE 4534/udp

HEALTHCHECK --interval=5s --timeout=5s --start-period=10s --retries=3 \
    CMD nc -z -v -u 127.0.0.1 4534 || exit 1

VOLUME [ "/armagetron" ]

ENTRYPOINT [ "entrypoint.sh" ]