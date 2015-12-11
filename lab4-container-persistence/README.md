Lab IV: Persist a container's state and data
===============================

## Description

In this lab, you'll learn how to persist data for containers.  Unlike using virtual machines, containers require that data that must be stored (or persisted) outside of the container itself.  A primary reason behind this is that `Docker` containers are not immediately portable between hosts.  So in order to enable portability of the container between hosts, data must be persisted outside of the container.

### Lab setup

Each of you has been handed a piece of paper with a machine that has Docker and REX-Ray installed. SSH into your machine

#### Mac/Linux
Use Terminal
`$ ssh student001a@IPADDRESS`

#### Windows
Use PuTTy

## Persist Data Between Containers
** small presentation on why persistence**

Each machine has [REX-Ray](https://github.com/emccode/rexray) installed which is a tool that enables consumption of storage for containers. In this lab it is currently configured for AWS EC2 and EBS usage.

Let's take a quick tour of `REX-Ray` commands and see how we can manage storage. Use `rexray help` to see the available commands.

```
REX-Ray:
  A guest-based storage introspection tool that enables local
  visibility and management from cloud and storage platforms.

Usage:
  rexray [flags]
  rexray [command]

Available Commands:
  version     Print the version
  adapter     The adapter manager
  device      The device manager
  volume      The volume manager
  snapshot    The snapshot manager
  service     The service controller
  help        Help about any command

Global Flags:
  -c, --config="/home/student002a/.rexray/config.yml": The REX-Ray configuration file
  -h, --host="tcp://:7979": The REX-Ray service address
  -l, --logLevel="warn": The log level (panic, fatal, error, warn, info, debug)
  -v, --verbose[=false]: Print verbose help information

Use "rexray [command] --help" for more information about a command.
```

To view the types of drivers available, use the `rexray adapter types` command to see a similar output:
```
$ rexray adapter types
Storage Driver: XtremIO
Storage Driver: docker
Storage Driver: linux
Storage Driver: ec2
Storage Driver: Openstack
Storage Driver: Rackspace
Storage Driver: ScaleIO
```

`REX-Ray` is also a system level service which is what enables `Docker` to natively request access to persistent storage. You can `start`, `stop`, `restart`, and get the `status`. To the available commands type `rexray service --help`. Do not run these commands during the lab exercise.

Perform `rexray device get` to retrieve a list of all the mounts on the host. You will recieve something similar to:
```
INFO[0000] getting mounts                                deviceName= driverName=linux mountPoint=
- id: 17
  parent: 22
  major: 0
  minor: 15
  root: /
  mountpoint: /sys
  opts: rw,nosuid,nodev,noexec,relatime
  optional: ""
  fstype: sysfs
  source: sysfs
  vfsopts: rw
- id: 18
  parent: 22
  major: 0
  minor: 3
  root: /
  mountpoint: /proc
  opts: rw,nosuid,nodev,noexec,relatime
  optional: ""
  fstype: proc
  source: proc
  vfsopts: rw
  ...
  ...
```

We will come back to the `rexray snapshot` manager a bit later (you can probably guess what that's for), for now lets checkout `rexray volume` manager to get started making volumes.

In order to create a volume let's look at the help for the `create` command by running `rexray volume create --help`:

```
Flags:
      --availabilityzone="": specify a availabilityzone
      --iops=0: specify desired IOPS
      --runasync[=false]: whether to wait or not for volume creation
      --size=0: the size in GB
      --snapshotid="": create a volume from an existing snapshot ID
      --volumeid="": create a volume from an exisating volume ID
      --volumename="": the desired volume name
      --volumetype="": the desired volume type
```

Create a new volume: `rexray volume create --size=5 --volumename=<volName>` For the examples, I will be using `student001`. By default, this will create a standard volume type without any guarantee of IOPS in our AZ.
```
$ rexray volume create --size=5 --volumename=<volName>
INFO[0000] Waiting for volume creation to complete
name: yourVolumeName
volumeid: vol-2765e5cb
availabilityzone: us-east-1b
status: available
volumetype: standard
iops: 0
size: "5"
networkname: ""
attachments: []
```

Let's make sure that you are have unexported the `Docker Swarm` configuration commands so you are addressing a `Docker` engine directly.

1. `$ unset DOCKER_TLS_VERIFY`
2. `$ unset DOCKER_HOST`


Now it's time to use this volume inside of a docker container:
```
$ docker run -ti --name temp --volume-driver=rexray -v <volName>:/test busybox
```

Once we are in our container, let's validate that the external volume is mounted as expected.  The following path shows the `/dev/xvdb` volume mounted to `/test`.
```
/ # df /student001
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/xvdb             16382888     45036  15482608   0% /test
```

Once we are in our container, change directories to the `/test` folder and create a new file
```
/ # ls
bin         dev         etc         home        proc        root        student001  sys         tmp         usr         var
/ # cd /test
/test # ls
/test # touch hellopersistence
```

Exit the container with `ctrl+d`. All of our data that resides in `/test` will persist after the container lifetime. To prove this, delete the container:
```
$ docker rm temp
```

Create a new container by mounting the same volume:
```
$ docker run -ti --rm --volume-driver=rexray -v <yourVolumeName>:/test busybox
```

Now enter `ls /test` and you will see that our file has persisted. exit the container with `ctrl+d`.

**Notice how we have added a `--rm` flag here. This means the container itself is completely temporary, and removed immediately after the container is stopped. A quick "gotcha" is that this will also remove the persisted volume. Use this flag with extreme caution.**

## Docker 1.9 New and Enhanced Features for Data Persistence
Docker can now control the creation of volumes and specification of advanced volume options. Instead of creating volumes directly from REX-Ray, we can create them with Docker:
```
$ docker volume create --driver=rexray --name=<yourVolumeName2> --opt=volumetype=io1 --opt=iops=100 --opt=size=10
```

This command will take a few seconds, but the output will be the name of the volume that has been created.

Alike the `rexray volume ls` command, the `docker volume ls` command will return volumes on the host and the driver associated with it.

```
student001b@student001a:~/composetest$ docker volume ls
DRIVER              VOLUME NAME
rexray              yourVolumeName2
local               6c3c2a3249651a0f5f72022f010d3b4dbd38e58d698a62714f491c524681a555
local               f3622f5cd30063764da8ada3680c4d4bd07409188e34333edc435069fc52dd60
local               91886bdf427bcc583aad2aa1e0a68b54c532a81ccb5b0d317b70204cb7da7836
```

Next let's ensure we begin talking with `Docker Swarm` again.

1. `$ export DOCKER_TLS_VERIFY=1`
2. `$ export DOCKER_HOST=tcp://$(curl http://169.254.169.254/latest/meta-data/public-ipv4):3376`


Let's do the same thing as before to prove persistence but let's do it BETWEEN machines using constraints!

```
$ docker run -tid --name hosta -e constraint:node==*a* --volume-driver=rexray -v <yourVolumeName2>:/test busybox

$ docker ps
```

`docker ps` should show the name as the following `<studentID>a/hosta`.


Attach to the host with `$ docker attach hosta` and verify that the volume is mounted as expected.  Notice how `/dev/xvdb` is mounted to `/test`

```
/ # df /student001a/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/xvdb             10190136     23028   9626436   0% /test
```


Create a new file inside of the `/test` path.
```
/ # cd /test
/test # touch mynewawesomefile
/test # exit
```

The container has quit. start another one on host `b`
```
$ docker run -ti --name hostb -e constraint:node==*b* --volume-driver=rexray -v <yourVolumeName2>:/test busybox
```

Go to the `/test` directory and verify there is `mynewawesomefile`.

Exit out a do a little clean up.
```
$ docker rm hosta
$ docker rm hostb
$ docker volume rm <yourVolumeName2>
```

## Congratulations!!

You have created containers with the same persistent volume that enables portability between hosts!
