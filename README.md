3-Hour Docker Storage and Networking Workshop Training
===============================

## Description

In this session you will learn how to use the basics of Docker Engine, how to search for Docker images on Docker hub, how to run your images and connect to the applications inside them, deploy multi-container applications using Compose, build Dockerfiles, configure a Swarm cluster, use [REX-Ray](https://github.com/emccode/rexray) for storage persistence, and network containers between hosts.

The workshop is intended for Docker beginners, intermediate users, and those interested in storage and networking.

If you're new to Docker and looking for a great introduction, this will is a good opportunity to get a hands-on introduction to the fundamentals of the Docker Platform.

To get started on your own outside the classroom, follow the directions specified in [/prep/readme](https://github.com/emccode/training/blob/master/docker-storage-networking/prep/README.md) to get your AWS instances started. The slides are available at [Docker 1.9 Workshop](http://www.slideshare.net/EMCCODE/docker-19-workshop).

### Part I: Introduction to the Docker Platform
 - Overview & Intro Presentation (20 minutes)

### Lab I: Run your first container

 - Start it
 - See the logs
 - See which ports are open
 - Connect to the container

### Lab II: Create A Compose File

 - Install Docker Compose
 - Create a python application
 - Create a Dockerfile
 - Deploy the App

### Lab III: Create A Swarm Cluster

 - Get a Swarm ID
 - Configure Swarm Agents
 - Configure Swarm Master
 - Deploy containers to Swarm pool

### Lab IV: Container Persistence

 - Slide on storage persistence and it's necessity
 - Tour of [REX-Ray](https://github.com/emccode/rexray)
 - Create Volume with [REX-Ray](https://github.com/emccode/rexray)
 - Demo persistence between container instances
 - Docker 1.9 Enhanced Storage features
 - Create volume with Docker Volume commands
 - Demo persistence between host instances

### Lab V: Networking Between Container Hosts

 - Destroy Existing Swarm Setup
 - Create New Swarm using Consul
 - Create overlay networks
 - Attach containers to networks
 - Verify connectivity between containers
