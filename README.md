3-Hour Docker Storage and Networking Workshop Training
===============================

## Description

In this session you will learn how to use the basics of Docker Engine, how to search for Docker images on Docker hub, how to run your images and connect to the applications inside them, deploy multi-container applications using Compose, build Dockerfiles, configure a Swarm cluster, use storage persistence, and network containers between hosts.

The workshop is intended for Docker beginners, intermediate users, and those interested in storage and networking.

If you're new to Docker and looking for a great introduction, this will is a good opportunity to get a hands-on introduction to the fundamentals of the Docker Platform.

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

WIP! Check out https://blog.docker.com/2015/11/docker-1-9-production-ready-swarm-multi-host-networking/ for some ideas on what to test out!

 - Slide on storage persistence and it's necessity
 - Persistence between container instances
 - Docker 1.9 Enhanced Storage features
 - Create volume with Docker Volume commands
 - Demo persistence between host instances

### Lab V: Networking Between Container Hosts

WIP! Check out https://blog.docker.com/2015/11/docker-1-9-production-ready-swarm-multi-host-networking/ for some ideas on what to test out!

 - Destroy Existing Swarm Setup
 - Create New Swarm using Consul
 - Create overlay networks
 - Attach containers to networks
 - Verify connectivity between containers

## Other info

 This is an altered version of [https://github.com/emccode/training/](https://github.com/emccode/training/tree/master/docker-workshops/docker-storage-networking).
