Docker sits righ in the *middle* of some of the most enabling technologies of the
last decade (virtualization, configuration management, deployment automation).

Think of a container not as a virtual machine but a very lighweight wrapper
around a single Unix *process*.

Docker revision control

1. filesystem layers
2. image tags

Terminology
-----------

Docker server - the `docker` command run in daemon mode on a Linux host:
    
    $ sudo docker -d -H unix:///var/run/docker.sock -H tcp://0.0.0.0:2375

Docker image - one or more filesystem layers and metadata that represent all
the files required to run a Dockerized application

Docker container - a Linux container that has been instantiated from a Docker
image

Working with Docker images
--------------------------

To launch a container

* download a public image
* create your own

To create a custom image you need a `Dockerfile` - each line in a Dockerfile creates a new image layer that is stored by Docker

Building an image

    git clone https://github.com/spkane/docker-node-hello.git
    docker build -t example/docker-node-hello:latest .

Running an image

    # 'example/docker-node-hello:latest' is a tag
    docker run -d -p 8080:8080 example/docker-node-hello:latest

Stopping an image

    docker ps
    docker stop <container_id>

Working with Docker containers
------------------------------

A container is a self-contained execution environment that shares the kernel of
the host system and which is (optionally) isolated from other containers in the
system.

Containers are a *Linux only* technology.

Creating a container

    docker run --rm -ti ubuntu /bin/bash 

* run - `create` + `start`
* --rm - delete the container when it exits
* -t - allocate a pseudo-TTY
* -i - interactive session, e.i. keep STDIN open
* /bin/bash - executable to run within the container

Remove container

    docker ps -a
    docker rm <container_id>

Remove image

    docker images
    docker rmi <image_id>

Delete all containers/images on your Docker host

    docker rm  $(docker ps -a -q)
    docker rmi $(docker images -q -)

Sources
-------

* Docker: Up & Running (2015)
