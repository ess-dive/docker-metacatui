FROM httpd:2.4

RUN echo "METACAT_DOMAIN=\${METACAT_DOMAIN}" >> /etc/profile.d/apache.sh \
    && echo "METACAT_MN_DOMAIN=\${METACAT_MN_DOMAIN}" >> /etc/profile.d/apache.sh \
    && chmod +x /etc/profile.d/apache.sh
ADD httpd.conf /usr/local/apache2/conf/httpd.conf
ADD httpd-ssl.conf /usr/local/apache2/conf/extra/httpd-ssl.conf
ADD metacatui/metacatui/src/main/webapp/ /usr/local/apache2/htdocs/metacatui


