FROM alpine:edge

#ARG OBFS4PROXY_PACKAGE_VERSION=0.0.11-r4
RUN apk --no-cache add squid tor privoxy ca-certificates \
    apk --no-cache add obfs4proxy  --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing\
    ln -sf /dev/stdout /var/log/privoxy/logfile && \
    chown -R squid:squid /var/cache/squid && \
    chown -R squid:squid /var/log/squid
    
ENV LISTING_PORT="5090"
ENV OBFS4_ADR="obfs4 207.148.108.221:443 7259F29EC35E385B25D1DD56A3B39B76BBE63940 cert=aMu33DOPGFQsjgLZ7JtKB6Eysn9kaN4ubcWbi2zsO+rAORC1eKDrDiGqXqkJD8ZLgY25QA iat-mode=0"
COPY torrc.template entrypoint.sh /
RUN chmod -c a+rX /torrc.template /entrypoint.sh
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

USER tor
VOLUME /var/lib/tor
CMD ["tor", "-f", "/tmp/torrc"]

# https://github.com/opencontainers/image-spec/blob/v1.0.1/annotations.md
ARG REVISION="0.0.1"
LABEL org.opencontainers.image.title="tor bridge providing obfs4 obfuscation protocol test" \
    org.opencontainers.image.source="https://github.com/iAHTOH/docker-tor-ps" \
    org.opencontainers.image.revision="$REVISION"
