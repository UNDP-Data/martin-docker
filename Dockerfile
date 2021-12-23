FROM urbica/martin
RUN apk add curl
RUN mkdir -p /etc/martin
#COPY config.yaml /etc/martin/config.yaml
COPY entrypoint.sh /etc/martin/entrypoint.sh

WORKDIR /etc/martin
ENTRYPOINT /etc/martin/entrypoint.sh