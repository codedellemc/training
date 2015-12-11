Lab III: Create A Swarm Cluster
===============================

## Description

In this lab you'll setup a Docker Swarm cluster with the machines you have been provided. Docker Swarm is native clustering for Docker. It allows you create and access a pool of Docker hosts using the full suite of Docker tools. Because Docker Swarm serves the standard Docker API, any tool that already communicates with a Docker daemon can use Swarm to transparently scale to multiple hosts.

### Lab setup

Each participant has been handed a piece of paper with two machines `student00Xa` and `student00Xb` with their associated IP addresses. Each machine has been provisioned by Docker Machine with Docker 1.9 and REX-Ray 0.2 installed for use. The SSH password for each host is the host name. ie. Host `student001a`'s password is `student001a`

#### Mac/Linux
Use Terminal
`ssh IPADDRESS -l student001a`

#### Windows
Use PuTTy

## Get A Swarm ID
Swarm uses a distributed key:value pair to cluster hosts together. The first step to creating a swarm on your network is to pull the Docker Swarm image. Then, using Docker, you configure the swarm manager and all the nodes to run Docker Swarm.

1. SSH into your `a` machine
2. `docker run --rm swarm:1.0.0 create` will use v1.0.0 of Swarm to create a new unique ID.
```
student001a@student001a:~$ docker run --rm swarm:1.0.0 create
Unable to find image 'swarm:1.0.0' locally
1.0.0: Pulling from library/swarm
2bc79aec8ea0: Pull complete
dc2fb86a875a: Pull complete
435e648d0f23: Pull complete
e16042a92d05: Pull complete
045bd7b00b5b: Pull complete
3caea1253d76: Pull complete
2b4c55187a27: Pull complete
6b40fe7724bd: Pull complete
Digest: sha256:989dd783c2a2e6decd3b60f52a8a99b81a2a7ff24c8b3fd7cb4b8bd699e61f6b
Status: Downloaded newer image for swarm:1.0.0
f29ab346337368c83f4087d21900b75d
```
3. Save that Token/Unique ID on the last line. (ie. `f29ab346337368c83f4087d21900b75d`).


## Configure Swarm Agents
Each host is going to act as a pool of resources for the cluster. Therefore, a swarm agent must be installed on each host. Create two SSH sessions for your hosts `a` and `b`. Replace `<your token>` with the Swarm token from earlier

1.
```
docker run -d --restart=always --name swarm-agent swarm:1.0.0 join --advertise $(curl http://169.254.169.254/latest/meta-data/public-ipv4):2376 token://<your token>

% Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                               Dload  Upload   Total   Spent    Left  Speed
100    12  100    12    0     0   3524      0 --:--:-- --:--:-- --:--:--  4000
e8017015d72df0638892ec48687b4255f9e887ed1768fc5f25bd18ce73dd0e03
```

Once that is done on both machines, perform a `docker ps` to verify the container is running.

## Configure Swarm Master
Now that each of our hosts are acting as resources for the pool, we have to have a manager of these resources. This manager will become the docker endpoint. This means we will redirect our docker engine commands to point to the swarm master. When we issue commands to create a new container, the swarm master is responsible for looking at the pool of resources and deciding where to place the container.

For this instance, let's use machine `a` as our Swarm Master.

Now run the Swarm Master container.
```
docker run -d --restart=always --name swarm-agent-master -p 3376:3376 -v /etc/docker:/etc/docker swarm:1.0.0 manage --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server.pem --tlskey=/etc/docker/server-key.pem -H tcp://0.0.0.0:3376 --strategy spread  token://<your token>
```

Now, do `docker ps`. The output of this is a result of showing every container only on this host. We are going to configure `a`'s' docker engine to point to the swarm master. Replace HOSTIP with the PUBLIC IP.

These hosts were provisioned with Docker Machine. By default, Docker Machine installs Docker Engine with TLS certificates to encrypt the communication and service. Docker Machine can automatically configure Swarm for you, but we are configuring it manually as part of this training, thus we have to take a few extra steps to make this all work.

1. Create a new directory: `mkdir ~/.docker`
2. Copy `server.pem`: `sudo cp /etc/docker/server.pem ~/.docker/cert.pem`
3. Copy `server-key.pem` : `sudo cp /etc/docker/server-key.pem ~/.docker/key.pem`
4. Copy `ca.pem`: `sudo cp /etc/docker/ca.pem ~/.docker/ca.pem`

Setup environment variables to point the Docker CLI to the Swarm Master

1. `export DOCKER_TLS_VERIFY=1`
2. `export DOCKER_HOST=tcp://$(curl http://169.254.169.254/latest/meta-data/public-ipv4):3376`

Now do `docker ps` again. What happened? We can see that there are now no containers running (unless you had containers other than Swarm previously running).

Run `docker info` and you will see something different than before
```
student001a@student001a:~$ docker info
Containers: 8
Images: 8
Role: primary
Strategy: spread
Filters: health, port, dependency, affinity, constraint
Nodes: 2
 student012a: 54.174.23.28:2376
  └ Containers: 7
  └ Reserved CPUs: 0 / 1
  └ Reserved Memory: 0 B / 1.017 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.19.0-30-generic, operatingsystem=Ubuntu 14.04.3 LTS, provider=amazonec2, storagedriver=aufs
 student012b: 54.173.131.60:2376
  └ Containers: 1
  └ Reserved CPUs: 0 / 1
  └ Reserved Memory: 0 B / 1.017 GiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.19.0-30-generic, operatingsystem=Ubuntu 14.04.3 LTS, provider=amazonec2, storagedriver=aufs
CPUs: 2
Total Memory: 2.033 GiB
Name: 6ebfc1be0989
```

## Using Docker with Swarm

Now that you have a two container hosts combined with Swarm, use the `docker run` command on machine `a` that has been configured to point to the swarm master.

Run `docker run -tid busybox` and then to a `docker ps`. If you notice, the name of the container has changed and now has a prefix. This prefix indicates what machine it's running on.  The following shows the new container running from `student002b`.

```
CONTAINER ID        IMAGE               COMMAND             CREATED                  STATUS                  PORTS                          NAMES
92c2cecf17b7        busybox             "sh"                Less than a second ago   Up Less than a second                                  student002b/elegant_mahavira
```

Run `docker run -tid busybox` a few more times. You will see that the amount of containers on each host is spread evenly. This is because we are using the `spread` strategy for Swarm. The other options would have been `binpack` and `random`.

The `spread` and `binpack` strategies compute rank according to a node’s available CPU, its RAM, and the number of containers it is running. The `random` strategy uses no computation. It selects a node at random and is primarily intended for debugging.

Your goal in choosing a strategy is to best optimize your swarm according to your needs.

Under the `spread` strategy, Swarm optimizes for the node with the least number of running containers. This results in containers spread thinly over many machines. The advantage of this strategy is that if a node goes down you only lose a few containers.

The `binpack` strategy causes Swarm to optimize for the node which is most packed to ensure the least amount of running container hosts for satisfying requirements. This avoids fragmentation because it leaves room for bigger containers on unused machines. The strategic advantage of binpack is that you use fewer machines as Swarm tries to pack as many containers as it can on a node.

The `random` strategy, like it sounds, chooses nodes at random regardless of their available CPU or RAM.

## Congratulations!!

You've configured a container host cluster using `Docker Swarm`.
