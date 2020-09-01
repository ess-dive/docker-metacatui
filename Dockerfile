FROM httpd:2.4

# Docker Image Arguments
#  These may be overriden when
#  The image is build
ARG METACATUI_UID=4999
ARG METACATUI_GID=5000


ENV METACAT_UI_DOMAIN=localhost
ENV METACAT_MN_DOMAIN=localhost
ENV METACAT_APP_CONTEXT=metacat
ENV SSL_SERVER_KEY=conf/server.key
ENV SSL_SERVER_CERT=conf/server.crt
ENV SSL_SERVER_CHAIN=conf/server-ca.crt

RUN rm -rf htdocs/*
ADD metacatui/src htdocs
ADD httpd.conf.patch httpd-ssl.conf.patch robots.tmpl /tmp/
ADD ca-bundle.crt /usr/local/apache2/conf/ssl.crt/ca-bundle.crt
ADD image_version.yml .


RUN apt-get update && apt-get install -y --no-install-recommends \
        gettext-base patch libcap2-bin\
    && rm -rf /var/lib/apt/lists/*

# Merge recommended settings for apache into default configuration
RUN groupadd -g ${METACATUI_GID} metacatui \
    && useradd -u ${METACATUI_UID} -g ${METACATUI_GID} -c 'MetacatUI User'  --no-create-home metacatui \
    && chown -hR metacatui:metacatui /usr/local/apache2/ \
    && chmod g+ws  /usr/local/apache2/htdocs/ \
    && patch conf/extra/httpd-ssl.conf /tmp/httpd-ssl.conf.patch \
    && patch conf/httpd.conf /tmp/httpd.conf.patch

#setcap to bind to privileged ports as non-root
RUN setcap 'cap_net_bind_service=+ep' /usr/local/apache2/bin/httpd
RUN getcap /usr/local/apache2/bin/httpd

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

USER metacatui
WORKDIR htdocs

EXPOSE 80

CMD ["httpd","-D","FOREGROUND"]
