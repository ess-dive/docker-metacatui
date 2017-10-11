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

    METACAT_UI_TAG=2_0_0RC1
    ./setup.sh $METACAT_UI_TAG
    docker build  -t metacatui:$METACAT_UI_TAG .
    
Run the docker container 
    
    docker run  -p 80:80  \
           -e METACAT_DOMAIN=localhost   \
           -e METACAT_MN_DOMAIN=mn.example.com  \
           --name metacatui \
           -it metacatui:$METACAT_UI_TAG

The metacat UI should be able to be accessed at `http://localhost/metacatui`


# License

TBD

# Supported Docker versions

This image is officially supported on Docker version 17.09.0.


# People

Current Project Team Members:

 * [@vchendrix](https://github.com/vchendrix)
