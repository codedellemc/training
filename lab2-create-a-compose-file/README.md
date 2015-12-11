Lab II: Create A Compose File
===============================

## Description

In this lab you'll learn how to create a Docker Compose file to programmatically deploy an application with code. We will also learn how to use a Dockerfile. A Dockerfile is a text document that contains all the commands a user could call on the command line to assemble an image. Compose is a tool for defining and running multi-container applications with Docker. With Compose, you define a multi-container application in a single file, then spin your application up in a single command which does everything that needs to be done to get it running.

### Lab setup

Each participant has been handed a piece of paper with two machines `student00Xa` and `student00Xb` with their associated IP addresses. Each machine has been provisioned by Docker Machine with Docker 1.9 and REX-Ray 0.2 installed for use. The SSH password for each host is the host name. ie. Host `student001a`'s password is `student001a`

#### Mac/Linux
Use Terminal
`ssh IPADDRESS -l student001a`

#### Windows
Use PuTTy

## Install Compose
Before we begin, we have to install Docker Compose. As of this writing, the latest release is [v1.5.0](https://github.com/docker/compose/releases)

```
$ sudo -s
$ curl -L https://github.com/docker/compose/releases/download/1.5.0/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
$ exit
```

## Create an Application
We will follow the steps as listed on [Docker Compose Quickstart](https://docs.docker.com/compose/)

Create a new directory to host the compose file
```
$ cd ~
$ mkdir composetest
$ cd composetest
```

Inside this directory, create app.py, a simple web app that uses the Flask framework and increments a value in Redis.
```
$ nano app.py
```

copy and paste the following into `app.py`. Use `CTRL+X` and `Y` to save the file:
```
from flask import Flask
from redis import Redis

app = Flask(__name__)
redis = Redis(host='redis', port=6379)

@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello World! I have been seen %s times.' % redis.get('hits')

if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)
```

Next, define the Python dependencies in a file called `requirements.txt`:
```
nano requirements.txt
```

Copy and paste:
```
flask
redis
```

Now, create a Docker image containing all of your app’s dependencies. You specify how to build the image using a file called `Dockerfile`:

```
nano Dockerfile
```

There are more settings of course, and we'd recommend you to read up on them at the [Dockerfile reference](https://docs.docker.com/reference/builder/).:

Copy and paste:
```
FROM python:2.7
ADD . /code
WORKDIR /code
RUN pip install -r requirements.txt
CMD python app.py
```

Next, define a set of services using `docker-compose.yml`:
```
nano docker-compose.yml
```

The following `docker-compose.yml` file defines two containers `web` and `redis` that are connected via specifying the `links` parameter.  The content of the container is specified in two ways.  First int the `web` container, it is told to `build: .` which ensures the `Dockerfile` specified above with the Python app is built.  The `redis` container specifies `image: redis` which ensures an official image of `redis` is pulled.  The `web` container has a `ports:` parameter specified which exposes the `5000` port to the outside world.  The last portion is related to the exposing this working directory to the `web` container, this is done through the `volumes` parameter with `.:/code`. Check out all the other attributes at the [docker-compose.yml reference](https://docs.docker.com/compose/yml/).

Copy and paste:
```
web:
  build: .
  ports:
   - "5000:5000"
  volumes:
   - .:/code
  links:
   - redis
redis:
  image: redis
```

Now lets run it!:
```
$ docker-compose up
```

You are presented with the logging output of both containers. Access the application by going to `http://PUBLICIP:5000` Refresh the page and watch the log.

Now, we can't render our host useless by looking at logs. So stop the container by pressing `CTRL+c`. A `docker ps` will show that these containers have been stopped. Bring them up again in a detached state.:
```
docker-compose up -d
```
Go back to your web application at `http://PUBLICIP:5000` and you'll see that it's all working.

```
Hello World! I have been seen 1 times.
```

Try refreshing and you will see that the `redis` container is holding our state, and maintains an incremented counter for every page load.  With a `refresh` you should see this.

Press `ctrl-c` to stop the application.


## Congratulations!!
You have created your first multi-container appliation using `Docker Compose`.
