FROM urbica/martin

RUN apk add curl
RUN apk add gettext

RUN mkdir -p /etc/martin
COPY entrypoint.sh /etc/martin/entrypoint.sh
RUN chmod +x /etc/martin/entrypoint.sh
RUN echo $(ls -1 /etc/martin)
WORKDIR /etc/martin
ENTRYPOINT ["/etc/martin/entrypoint.sh"]