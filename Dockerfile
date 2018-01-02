FROM httpd:2.4

ENV METACAT_UI_DOMAIN=localhost
ENV METACAT_MN_DOMAIN=localhost
ENV METACAT_APP_CONTEXT=metacat
ENV SSL_SERVER_KEY=conf/server.key
ENV SSL_SERVER_CERT=conf/server.crt
ENV SSL_SERVER_CHAIN=conf/server-ca.crt

ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
ADD metacatui/src /tmp/metacatui
ADD ca-bundle.crt /usr/local/apache2/conf/ssl.crt/ca-bundle.crt
RUN rm -rf htdocs/*

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["httpd","-D","FOREGROUND"]