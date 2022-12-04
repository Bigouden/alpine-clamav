FROM alpine:3.17
LABEL maintainer="Thomas GUIRRIEC <thomas@guirriec.fr>"
ENV USERNAME='clamav'
COPY apk_packages /
RUN xargs -a /apk_packages apk add --no-cache --update \
    && rm -rf \
         /etc/clamav \
         /tmp/* \
         /root/.cache/* \
         /var/cache/* \
    && mkdir /var/run/clamav \
    && touch /var/run/clamav/clamd.sock \
    && chown -R ${USERNAME}:${USERNAME} /var/run/clamav
COPY --chown=${USERNAME}:${USERNAME} clamav /etc/clamav
COPY --chown=${USERNAME}:${USERNAME} --chmod=500 entrypoint.sh /
COPY --chown=${USERNAME}:${USERNAME} --chmod=500 healthcheck.sh /
USER clamav
WORKDIR /etc/clamav/
EXPOSE 3310/tcp
HEALTHCHECK CMD /healthcheck.sh
VOLUME ["/var/lib/clamav"]
ENTRYPOINT ["/entrypoint.sh"]
