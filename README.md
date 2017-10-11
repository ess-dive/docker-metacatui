# Metacat UI
<img src="https://knb.ecoinformatics.org/knb/docs/_images/metacat-logo-darkgray.png" 
alt="metacat" height="75" width="65"/>

*The official metacat docker image, made in a collaboration between NCEAS and LBNL*

## What is Metacat UI?

*from [github.com/NCEAS/metacatui](https://github.com/NCEAS/metacatui)*

MetacatUI is a client-side web interface for querying Metacat servers and other servers 
that implement the DataONE REST API.

## Usage
The Metacat UI docker image requires access to a Metacat member node
REST API


# How to use this image

Build the docker metacat image:

*Visit [github.com/NCEAS/metacatui/releases](https://github.com/NCEAS/metacatui/releases) to discover 
Metacat UI release tags*

    METACAT_UI_TAG=<git tag>
    ./build.sh $METACAT_UI_TAG
    
Run the docker container over HTTP:
    
    docker run  -p 80:80  \
           -e METACAT_DOMAIN=localhost   \
           -e METACAT_MN_DOMAIN=mn.example.com  \
           --name metacatui \
           -it metacatui:$METACAT_UI_TAG
           
Run the docker container with SSL:
  
*Create Self-signed SSL certificates*

    openssl req -x509 -nodes -days 1095 -newkey rsa:2048 -out server.crt \
         -keyout server.key \
         -subj "/C=US/ST=California/L=Berkeley/O=LBNL/OU=CRD/CN=localhost"


*Run the dccker container over HTTPS*
    
    docker run  -p 443:443  \
           -e ENABLE_SSL=1 \
           -v ${PWD}/server.crt:/usr/local/apache2/conf/server.crt \
           -v ${PWD}/server.key:/usr/local/apache2/conf/server.key \
           -e METACAT_DOMAIN=localhost   \
           -e METACAT_MN_DOMAIN=mn.example.com  \
           --name metacatui-secure \
           -it metacatui:$METACAT_UI_TAG         


The metacat UI should be able to be accessed at `http://localhost/metacatui`


# License

TBD

# Supported Docker versions

This image is officially supported on Docker version 17.09.0.


# People

Current Project Team Members:

 * [@vchendrix](https://github.com/vchendrix)
