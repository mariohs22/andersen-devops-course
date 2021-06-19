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
docker run -p 8080:8080 mariohs22/task5
```

After docker image is running, send appropriate JSON string to port 8080 on localhost. You may use [Postman](https://www.postman.com/) or execute command like this:

```
curl -d'{"animal":"elephant", "sound":"whoooaaa", "count": 4}' http://127.0.0.1:8080
```

## Task explanation

The minimum docker image size is achieved by using two techniques: python compiler and docker multi-stage build. I used [Nuitka](https://nuitka.net/pages/overview.html) for compile python app to linux executable. The Docker [multi-stage build](https://docs.docker.com/develop/develop-images/multistage-build/) technique also used to down the image size. At first stage the application is compiled by Nuitka and removed all unnecessary files from app directory. The second stage is the build scratch docker image with copying app directory to it.

####Finally, the size of the resulting docker image is **32.98Mb**.
