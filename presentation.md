# Docker "102" Training

## Presented by ![codelogo](http://emccode.github.io/images/badge.png) and ![dockerlogo](http://fedoramagazine.org/wp-content/uploads/2013/09/docker.png)

---

![](http://kendrickcoleman.com/slides/images/emccode-github.png)

---

# Current Projects

* [REX-Ray](https://github.com/emccode/rexray)
* [dvdcli](https://github.com/emccode/dvdcli)
* [mesos-module-dvdi](https://github.com/emccode/mesos-module-dvdi)
* [machine-extensions](https://github.com/kacole2/machine/releases)
* [fuel-scaleio](https://github.com/emccode/fuel-plugin-scaleio)

![filtered](http://emccode.github.io/images/badge.png)

---

# Docker Stats

* 25,000+ GitHub Stars
* 425M+ Docker Engine Downloads
* 100,000+ "Dockerized" applications Docker Hub
* 180+ Docker Meetup Groups in 50 Countries
* 950+ Community Contributers
* 50,000 3rd Party projects on GitHub using Docker in PaaS, OS, CI, and more

![filtered](http://www.shadowandy.net/wp/wp-content/uploads/docker.png)

---

# Why Docker?

* Works Everywhere (multi-arch, multi-OS, any cloud)
* Work for Everyone (dev, ops, & devops)
* Isolation (Cgroups, Namespaces)
* Lightweight (Binary, Dockerfile)
* Simplicity (Layers, Dockerfile)

![filtered](http://assets.mediaagility.com.storage.googleapis.com/wp_app/docker_2015.png)

---

# Why Docker?

* Workflow (CI, Distributed Architecture, Faster Delivery)
* Scaleabe and Dense
* Community (OSS, GitHub)
* Ecosystem
* Security, Orchestration, Networking & Storage

![filtered](http://assets.mediaagility.com.storage.googleapis.com/wp_app/docker_2015.png)

---

# Why It Makes Sense?

* Developer: Build Once, Run Anywhere
* Operator: Configure Once, Run Anything

![](http://kendrickcoleman.com/slides/images/docker000.png)

---

![fit](http://kendrickcoleman.com/slides/images/docker000.png)

---

![fit](http://kendrickcoleman.com/slides/images/docker001.png)

---

# Docker Platform

![filtered](http://assets.mediaagility.com.storage.googleapis.com/wp_app/docker_2015.png)

---

# Docker Engine

* Runs on Linux to create the operating environment for your distributed applications. The in-host daemon communicates with the Docker client to execute commands to build, ship and run containers.

`docker run -tid busybox`

![fit right](https://www.docker.com/sites/default/files/products/product%20-%20engine.png)

---

# Docker Registry

* Application dedicated to the storage and distribution of your Docker images

![fit right](https://camo.githubusercontent.com/1e11d429705bf6695b79d24966cb1267c00b7df6/68747470733a2f2f7777772e646f636b65722e636f6d2f73697465732f64656661756c742f66696c65732f6f79737465722d72656769737472792d332e706e67)

---

# Docker Hub

* A cloud hosted service from Docker that provides registry capabilities for public and private content. Easily collaborate effortlessly with the broader Docker community or within your team on key content, or automate your application building workflows

![fit right](http://blog.docker.com/media/Capture.jpg)


---

# Docker Machine

* A tool to simplify the automatic creation, configuration, and management of Docker-enabled machines, whether they are VMs running locally in Virtualbox or in a cloud provider such as Amazon Web Services

`docker-machine create --driver virtualbox dev`

![fit right](https://rsmitty.github.io/img/posts/2015-06-23-docker-machine-and-openstack/dockermachine.png)

---

# Lab I: Run Your First Container

[https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/](https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/)

In this lab you'll learn use Docker, how to search for Docker images on Docker hub, and how to run your images and connect to the applications inside them.

---

# [fit] Docker CLI
    - docker build    #Build an image from a Dockerfile 
    - docker images   #List all images on a Docker host
    - docker run      #Run an image
    - docker ps       #List all running instances
    - docker stop     #Stop a running instance
    - docker rm       #Remove an instance
    - docker rmi      #Remove an image from Docker host

---

# Docker Compose

* Instead of having to build, run and manage each individual container for a distributed application, Docker Compose allows you to define your multi-container application with all of its dependencies in a single file, then spin your application up in a single command.

`docker-compose up -d`

![fit right](http://rafpe.ninja/wp-content/uploads/2015/12/docker-compose-logo-01.png)

---

# Lab II: Create A Compose File

[https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/](https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/)

Programmatically deploy an application with code and use a Dockerfile. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. Compose is a tool for defining and running multi-container applications.

---

# Docker Swarm

* Provides native clustering capabilities to turn a group of Docker engines into a single, virtual Docker Engine. With these pooled resources, you can scale out your application as if it were running on a single, huge computer

![fit right](http://devopscube.com/wp-content/uploads/2015/01/SWARM.png)

---

# Lab III: Create A Swarm Cluster

[https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/](https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/)

In this lab you'll setup a Docker Swarm cluster. Docker Swarm serves the standard Docker API, any tool that already communicates with a Docker daemon can use Swarm to transparently scale to multiple hosts.

---

# Data Persistence

![filtered](http://kendrickcoleman.com/slides/containerpersistence/images/gif/implosion.gif)

---

# Today's Apps Favor:

* stateless applications
* non-persistent data
* services (load balancers, routing, queuing, etc)

---

# Persistence last year #1

## database lives outside of a container

![fit right](http://kendrickcoleman.com/slides/containerpersistence/images/outsidedb.png)

---

# Persistence last year #2

## based on object stores

![fit right](http://kendrickcoleman.com/slides/containerpersistence/images/s3.png)

---

# Docker Data Volumes

### a directory with one or more containers that bypasses the Union File System
    - initialized during container creation
    - volumes can be shared amongst containers
    - changes to data volumes are made directly
    - changes will not be included during image update
    - volumes persist after container is deleted

---

# block/nas host mounts

![inline](http://kendrickcoleman.com/slides/containerpersistence/images/nfs.png)

`$ docker run -i -t -v nfs/host/mount/path:/container/folder/path busybox`

---

# Docker Volume Driver

* introduced in 1.7 Experimental
* merged into master in 1.8 [#14659](https://github.com/docker/docker/pull/14659)
* allows third-party container data management solutions to provide data volumes for containers which operate on data, such as databases, queues and key-value stores and other stateful applications that use the filesystem

---

#[fit] ELI5

---

![fit](http://kendrickcoleman.com/slides/containerpersistence/images/why00.png)

---

![fit](http://kendrickcoleman.com/slides/containerpersistence/images/why01.png)

---

![fit](http://kendrickcoleman.com/slides/containerpersistence/images/why02.png)

---

![fit](http://kendrickcoleman.com/slides/containerpersistence/images/why03.png)

---

![fit](http://kendrickcoleman.com/slides/containerpersistence/images/why04.png)

---

# REX-Ray

a volume plugin which is written in Go and provides advanced storage functionality for various platforms

[https://github.com/emccode/rexray](ttps://github.com/emccode/rexray)

![fit right](http://kendrickcoleman.com/slides/containerpersistence/images/rexray.png)

---

# Lab IV: Container Persistence

[https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/](https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking/)

Unlike using virtual machines, containers require that data that must be stored (or persisted) outside of the container itself.  A primary reason behind this is that `Docker` containers are not immediately portable between hosts.  Data must be persisted outside of the container.

---

# Lab V: Networking Between Container Hosts
