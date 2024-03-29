# Metacat UI
<img src="https://knb.ecoinformatics.org/knb/docs/_images/metacat-logo-darkgray.png" 
alt="metacat" height="75" width="65"/>

*The official metacat docker image, made in a collaboration between NCEAS and LBNL*


## What is Metacat UI?

*from [github.com/NCEAS/metacatui](https://github.com/NCEAS/metacatui)*

MetacatUI is a client-side web interface for querying Metacat servers and other servers 
that implement the DataONE REST API.


## Usage
The Metacat UI docker image requires access to a Metacat member node.

# How to use this image

## Image Environment Variables
The following environment variables are optional:

**ENABLE_SSL:** pass a value of `1` to enable the ssl configuration.
**ENABLE_REAL_IP:** pass a value of `1` to enable the injection of proxy headers to obtain the real incoming ipaddresses.
**ENABLE_REVERSE_PROXY:** pass a value of `1` to enable the reverse proxy.

**METACAT_UI_DOMAIN:** (default: 'localhost') The domain name of the 
metacatui application. This is used in the apache configuration. 
(e.g `ServerName ${METACAT_UI_DOMAIN}`)

**METACAT_MN_DOMAIN:** (default: 'localhost') The domain name of the 
metacat member node service. This is used in the apache configuration
as the http proxy request.  The metacat member node port must be `8080`.

**SSL_SERVER_KEY:** (default: '/usr/local/apache2/conf/server.key') File path to 
qqthe SSL Server Key

**SSL_SERVER_CERT:** (default: '/usr/local/apache2/conf/server.crt') File path to 
the SSL Server Certificate

**SSL_SERVER_CHAIN:** (default: '/usr/local/apache2/conf/server-ca.crt')
Point SSLCertificateChainFile at a file containing the
concatenation of PEM encoded CA certificates which form the certificate chain 
for the server certificate. Alternatively the referenced file can be the 
same as SSLCertificateFile when the CA certificates are directly appended to 
the server certificate for convenience.

## Image Logs
Apache access and error logs are written to `/var/logs/apache2`. Mount a volume to  `/var/logs/apache2` if you want to persist your logs.


## Building and Running 
Build the docker metacat image:

*Visit [github.com/NCEAS/metacatui/releases](https://github.com/NCEAS/metacatui/releases) to discover 
Metacat UI release tags*

The `build.sh` script will clone the [github.com/NCEAS/metacatui](https://github.com/NCEAS/metacatui) Github
repository, checkout the specified git tag and build the metacat docker image with the tag `metacat:<git tag>`.

    METACAT_UI_TAG=<git tag>
    ./build.sh $METACAT_UI_TAG
    
Run the docker container over HTTP:
    
    docker run  -p 80:80  \
           --name metacatui \
           -it metacatui:$METACAT_UI_TAG
           
*The metacat UI should be able to be accessed at `http://localhost/metacatui`*
           
Run the docker container with SSL:

*Create Root CA for self-signed certificate:

    openssl genrsa -out rootCA.key 2048
    openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 1024 \
        -subj "/C=US/ST=California/L=Berkeley/O=LBNL/OU=CRD/CN=localhost" \
        -out rootCA.pem
  
*Create Self-signed SSL certificates*

    openssl genrsa -out server.key 2048
    openssl req -new -subj "/C=US/ST=California/L=Berkeley/O=LBNL/OU=CRD/CN=localhost" \
       -key server.key -out server.csr
    openssl x509 -req -in server.csr -CA rootCA.pem -CAkey rootCA.key \
        -CAcreateserial -out server.crt -days 500 -sha256

*Run the docker container over HTTPS*
    
    docker run  -p 443:443  \
           -e ENABLE_SSL=1 \
           -v ${PWD/logs:/var/logs/apache2 \
           -v ${PWD}/server.crt:/usr/local/apache2/conf/server.crt \
           -v ${PWD}/server.key:/usr/local/apache2/conf/server.key \
           --name metacatui-secure \
           -it metacatui:$METACAT_UI_TAG         


*The metacat UI should be able to be accessed at `https://localhost/metacatui`*

## Patch httpd conf files

*Get the conf files from the latest image*

    docker pull httpd:2.4
    
*If the image updated, then determine if the conf files changed*
    
    docker run --entrypoint "/bin/cat" httpd:2.4  conf/httpd.conf > image-httpd.conf
    docker run --entrypoint "/bin/cat" httpd:2.4  conf/extra/httpd-ssl.conf > image-httpd-ssl.conf
    git diff image-httpd.conf image-httpd-ssl.conf
    
    
*If modifying the conf files, update `httpd.conf` and `httpd.conf`*  Then create the patch files.

    diff  -u image-httpd.conf httpd.conf > httpd.conf.patch 
    diff  -u image-httpd-ssl.conf httpd-ssl.conf > httpd-ssl.conf.patch
    
*Check the patch to see if the changes make sense*

    git diff httpd.conf.patch httpd-ssl.conf.patch
    
If everything makes sense, build and test the new image.  Commit all the changes to the repository.
# License

TBD

# Supported Docker versions

This image is officially supported on Docker version 17.09.0.
   

# People

Current Project Team Members:

 * [@vchendrix](https://github.com/vchendrix)
 * [@csnavely ](https://gitlab.com/csnavely)
 * [@shreddd ](https://gitlab.com/shreddd)
