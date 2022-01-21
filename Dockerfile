FROM urbica/martin

RUN apk add curl
RUN apk add gettext

RUN mkdir -p /etc/martin
COPY config.yaml /etc/martin/config.yaml
COPY entrypoint.sh /usr/bin/entrypoint.sh

WORKDIR /etc/martin
ENTRYPOINT /usr/bin/entrypoint.sh