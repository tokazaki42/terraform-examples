FROM alpine:3.12
RUN apk add --no-cache squid

RUN mkdir /etc/sudoers.d

RUN echo "squid ALL=(ALL) NOPASSWD: /bin/chown -R squid\:squid /var/log/squid, /bin/chown -R squid\:squid /var/cache/squid" >> /etc/sudoers.d/squid && \
    echo "Defaults:squid !requiretty" >> /etc/sudoers.d/squid && \
    chmod 440 /etc/sudoers.d/squid


ADD squid.conf /etc/squid/squid.conf

ADD docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod 755 /docker-entrypoint.sh

EXPOSE 8080
USER squid

ENTRYPOINT ["./docker-entrypoint.sh"]
