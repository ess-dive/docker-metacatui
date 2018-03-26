FROM httpd:2.4

ENV METACAT_UI_DOMAIN=localhost
ENV METACAT_MN_DOMAIN=localhost
ENV METACAT_APP_CONTEXT=metacat
ENV SSL_SERVER_KEY=conf/server.key
ENV SSL_SERVER_CERT=conf/server.crt
ENV SSL_SERVER_CHAIN=conf/server-ca.crt

ADD metacatui/src /tmp/metacatui
ADD httpd.conf.patch httpd-ssl.conf.patch /tmp/
ADD ca-bundle.crt /usr/local/apache2/conf/ssl.crt/ca-bundle.crt
RUN rm -rf htdocs/*

RUN apt-get update && apt-get install -y --no-install-recommends \
        patch \
    && rm -rf /var/lib/apt/lists/*

# merge recommended settings for apache into default configuration
RUN patch conf/httpd.conf /tmp/httpd.conf.patch \
    && patch conf/extra/httpd-ssl.conf /tmp/httpd-ssl.conf.patch

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["httpd","-D","FOREGROUND"]
