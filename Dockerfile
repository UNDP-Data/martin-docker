FROM maplibre/martin:main

RUN apk add curl
RUN apk add gettext
RUN mkdir -p /etc/martin
COPY config.yaml /etc/martin/config.yaml
COPY reactive_entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT "/usr/bin/entrypoint.sh"