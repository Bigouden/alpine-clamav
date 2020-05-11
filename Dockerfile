FROM alpine:3.11
LABEL maintainer="Thomas GUIRRIEC <thomas@guirriec.fr>"
COPY entrypoint.sh /
COPY healthcheck.sh /
RUN apk add --update --no-cache \
      bash \
      clamav \
      clamav-libunrar \
    && rm -rf \
         /tmp/* \
         /root/.cache/* \
    && mkdir /var/run/clamav \
    && touch /var/run/clamav/clamd.sock \
    && chown -R clamav:clamav /var/run/clamav \
    && chown clamav:clamav /entrypoint.sh \
    && chown clamav:clamav /healthcheck.sh \
    && chmod +x /entrypoint.sh \
    && chmod +x /healthcheck.sh
COPY clamav /etc/clamav
WORKDIR /etc/clamav/
EXPOSE 3310/tcp
USER clamav
HEALTHCHECK CMD /healthcheck.sh
ENTRYPOINT ["/entrypoint.sh"]
