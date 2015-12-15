Lab IV: Persist a container's state and data
===============================

## Description

In this lab, you'll learn how to persist data for containers.  Unlike using virtual machines, containers require that data that must be stored (or persisted) outside of the container itself.  A primary reason behind this is that `Docker` containers are not immediately portable between hosts.  So in order to enable portability of the container between hosts, data must be persisted outside of the container.

### Lab setup

Same as Lab 1.

Verify that you have the following software installed:

1. A 64-bit OS
2. [Docker Toolbox](https://www.docker.com/toolbox)

## Persist Data Between Containers
** small presentation on why persistence**

Adding a data volume
You can add a data volume to a container using the -v flag with the docker create and docker run command. You can use the -v multiple times to mount multiple data volumes. Let’s mount a single volume now in our web application container.

```
docker run -d -P --name web -v /webapp training/webapp python app.py
```

This will create a new volume inside a container at /webapp.

## Creating and mounting a data volume container

If you have some persistent data that you want to share between containers, or want to use from non-persistent containers, it’s best to create a named Data Volume Container, and then to mount the data from it.

Let’s create a new named container with a volume to share. While this container doesn’t run an application, it reuses the training/postgres image so that all containers are using layers in common, saving disk space.
```
$ docker create -v /dbdata --name dbdata training/postgres /bin/true
```

You can then use the --volumes-from flag to mount the /dbdata volume in another container.
```
$ docker run -d --volumes-from dbdata --name db1 training/postgres
```

And another:
```
$ docker run -d --volumes-from dbdata --name db2 training/postgres
```

In this case, if the postgres image contained a directory called /dbdata then mounting the volumes from the dbdata container hides the /dbdata files from the postgres image. The result is only the files from the dbdata container are visible.

You can use multiple --volumes-from parameters to bring together multiple data volumes from multiple containers.

You can also extend the chain by mounting the volume that came from the dbdata container in yet another container via the db1 or db2 containers.

```
docker run -d --name db3 --volumes-from db1 training/postgres
```

If you remove containers that mount volumes, including the initial dbdata container, or the subsequent containers db1 and db2, the volumes will not be deleted. To delete the volume from disk, you must explicitly call docker rm -v against the last container with a reference to the volume. This allows you to upgrade, or effectively migrate data volumes between containers.

## Docker 1.9 New and Enhanced Features for Data Persistence
Docker can now control the creation of volumes and specification of advanced volume options. Instead of creating volumes directly manually we can create them with Docker:
```
$ docker volume create --name=<yourVolumeName2> --opt=volumetype=io1 --opt=iops=100 --opt=size=10
```

This command will take a few seconds, but the output will be the name of the volume that has been created.


## Congratulations!!

You have created containers with the same persistent volume that enables portability between hosts!
