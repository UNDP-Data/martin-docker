FROM urbica/martin
RUN apk add curl
RUN apk add gettext
RUN mkdir -p /etc/martin
COPY entrypoint.sh /etc/martin/entrypoint.sh
WORKDIR /etc/martin
ENTRYPOINT /etc/martin/entrypoint.sh