FROM urbica/martin

RUN apk add curl
RUN apk add gettext

RUN mkdir -p /etc/martin
COPY entrypoint.sh /usr/bin/entrypoint.sh

WORKDIR /etc/martin
ENTRYPOINT /usr/bin/entrypoint.sh