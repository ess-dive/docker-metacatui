FROM httpd:2.4

ENV METACAT_UI_DOMAIN=localhost
ENV METACAT_MN_DOMAIN=localhost

ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
ADD metacatui/metacatui/src/main/webapp/ /usr/local/apache2/htdocs/metacatui

COPY docker-entrypoint.sh /usr/local/bin/
RUN ln -s usr/local/bin/docker-entrypoint.sh / # backwards compat
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 80
CMD ["httpd","-D","FOREGROUND"]