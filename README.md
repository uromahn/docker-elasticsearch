# Elasticsearch Docker Container

This repo contains a Dockerfile and related files to create an elasticsearch docker container.
The files are based off the original docker-library for elasticsearch v2.1 which can be found here: 
https://github.com/docker-library/elasticsearch/tree/master/2.1

The Dockerfile had to be modified since the GPG keys being pulled from ha.pool.sks-keyservers.net do not seem
to exist anymore.

**IMPORTANT: This Dockerfile will pull the latest elasticsearch v2.1 from their debian repository but the deb package
will currently not being verified using a GPG key. It must be re-implemented should this be important to you!**

This Dockerfile will also install Kibana V4.3.0 into this container and then install Sense which is a great web-based UI to
help during development with elasticsearch.

##How to Build This Image

You will need to have a local machine with a recent version of Linux and Docker for this.

Clone this repository and `cd` into the freshly cloned repo. The issue the command:

```
$ docker build -t elasticsearch .
```

to create the image.

##How to Use This Image

To expose the ports to the host run the command

```
$docker run -d -p 5601:5601 -p 9200:9200 -p 9300:9300 elasticsearch elasticsearch -Des.node.name="TestNode"
```

This image comes with a default set of configuration files for elasticsearch, but if you want to provide your own set of configuration files, you can do so via a volume mounted at /usr/share/elasticsearch/config:

```
$ docker run -d -v "$PWD/config":/usr/share/elasticsearch/config elasticsearch
```

This image is configured with a volume at /usr/share/elasticsearch/data to hold the persisted index data. Use that path if you would like to keep the data in a mounted volume:

```
$ docker run -d -v "$PWD/esdata":/usr/share/elasticsearch/data elasticsearch
```

This image includes EXPOSE 9200 9300 5601 (default http.port), so standard container linking will make it automatically available to the linked containers.

This image also has Kibana and Sense installed.
To start kibana, execute the command:

```
$ docker exec -d elasticsearch kibana
```
