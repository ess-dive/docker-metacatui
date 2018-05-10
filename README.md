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

**METACAT_UI_DOMAIN:** (default: 'localhost') The domain name of the 
metacatui application. This is used in the apache configuration. 
(e.g `ServerName ${METACAT_UI_DOMAIN}`)

**METACAT_MN_DOMAIN:** (default: 'localhost') The domain name of the 
metacat member node service. This is used in the apache configuration
as the http proxy request.  The metacat member node port must be `8080`.

**METACATUI_CONTEXT:** If this is set then the metacat ui application will
be located at this URI path.  Otherwise the application will be located
at the root URI.

**SSL_SERVER_KEY:** (default: '/usr/local/apache2/conf/server.key') File path to 
qqthe SSL Server Key

**SSL_SERVER_CERT:** (default: '/usr/local/apache2/conf/server.crt') File path to 
the SSL Server Certificate

**SSL_SERVER_CHAIN: Point SSLCertificateChainFile at a file containing the
concatenation of PEM encoded CA certificates which form the certificate chain 
for the server certificate. Alternatively the referenced file can be the 
same as SSLCertificateFile when the CA certificates are directly appended to 
the server certificate for convenience.

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
           -v ${PWD}/server.crt:/usr/local/apache2/conf/server.crt \
           -v ${PWD}/server.key:/usr/local/apache2/conf/server.key \
           --name metacatui-secure \
           -it metacatui:$METACAT_UI_TAG         


*The metacat UI should be able to be accessed at `https://localhost/metacatui`*


# License

TBD

# Supported Docker versions

This image is officially supported on Docker version 17.09.0.


# People

Current Project Team Members:

 * [@vchendrix](https://github.com/vchendrix)
