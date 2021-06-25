# Docker

**Current status: done**

## Task description

### Build a docker container for your python app

- this time it needs to listen port 8080, HTTP only
- the lighter in terms of image size it is - the most points you get
- the one who builds the smallest image gets even more points!

### Hints

- use the minimal possible setup
- 100Mb is a lot ;-)

## Task execution

Clone this repositiry and change dir to _task5_docker_. Execute these commands to build and run docker image:

```
docker build -t mariohs22/task5 .
docker run -it -p 8080:8080 mariohs22/task5
```

After docker image is running, send appropriate JSON string to port 8080 on localhost. You may use [Postman](https://www.postman.com/) or execute command like this:

```
curl -d'{"animal":"elephant", "sound":"whoooaaa", "count": 4}' http://127.0.0.1:8080
```

## Task explanation

The minimum docker image size is achieved by using two techniques: python compiler and docker multi-stage build. I used [Nuitka](https://nuitka.net/pages/overview.html) for compile python app to linux executable. The Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) technique also used to down the image size:

- the first stage is the preparation of Ubuntu linux image with installed python, nuitka compiler and upx utility for compression;
- the second stage is compiling python app and compress app executable file;
- the third stage is creating docker image from scratch with copying to it app files from previous stage.

#### Finally, the size of the resulting docker image is **20.4Mb**.

**But we can reduce image size even more!** Let's use Docker Hub, which always compess image layers on pushing images:

```
docker login
docker push mariohs22/task5
```

Now the size of image is **12.21Mb**. You can check it on Docker Hub: [https://hub.docker.com/repository/docker/mariohs22/task5/tags?page=1&ordering=last_updated](https://hub.docker.com/repository/docker/mariohs22/task5/tags?page=1&ordering=last_updated) or use command `docker save <docker_image_id> | gzip | wc --bytes`:

```
$ docker save 2a043d67a16a | gzip | wc --bytes
12591053
```

To retrieve compressed image from Docker Hub you can use command:

```
docker pull mariohs22/task5:latest
```
