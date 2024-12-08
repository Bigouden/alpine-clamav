# kics-scan disable=ae9c56a6-3ed1-4ac0-9b54-31267f51151d,aa93e17f-b6db-4162-9334-c70334e7ac28,d3499f6d-1651-41bb-a9a7-de925fea487b

ARG ALPINE_VERSION="3.21"

FROM alpine:${ALPINE_VERSION} AS builder
COPY --link apk_packages /tmp
# hadolint ignore=DL3018
RUN --mount=type=cache,id=builder_apk_cache,target=/var/cache/apk \
    apk add gettext-envsubst

FROM alpine:${ALPINE_VERSION}
LABEL maintainer="Thomas GUIRRIEC <thomas@guirriec.fr>"
ENV USERNAME="clamav"
# hadolint ignore=DL3018,SC2006
RUN --mount=type=bind,from=builder,source=/usr/bin/envsubst,target=/usr/bin/envsubst \
    --mount=type=bind,from=builder,source=/usr/lib/libintl.so.8,target=/usr/lib/libintl.so.8 \
    --mount=type=bind,from=builder,source=/tmp,target=/tmp \
    --mount=type=cache,id=apk_cache,target=/var/cache/apk \
    apk --update add `envsubst < /tmp/apk_packages` \
    && rm -rf \
         /etc/clamav \
    && mkdir /var/run/clamav \
    && touch /var/run/clamav/clamd.sock \
    && chown -R "${USERNAME}":"${USERNAME}" /var/run/clamav
COPY --link --chmod=755 clamav /etc/clamav
COPY --link --chmod=755 entrypoint.sh healthcheck.sh /
USER clamav
WORKDIR /etc/clamav/
EXPOSE 3310/tcp
HEALTHCHECK CMD /healthcheck.sh # nosemgrep
VOLUME ["/var/lib/clamav"]
ENTRYPOINT ["/entrypoint.sh"]
