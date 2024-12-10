`                          `**Docker**


**Docker** is a opensource software platformtool that allows you to build,test,deploy application using container.

**Container** is a runtime engine that allows developers to package application  with all parts needed such as libraries and other dependencies.containers contain the whole kit required for an application.so the application can run in isolated way in different environment.

**Docker images** is a file in the template formate is a set of instructions used to create a docker container in a read only format.

**Advantages** of using docker container is lightweight,fast delivery,reduce infrastructure cost.

**Docker Commands :**

**Docker containers**

**docker run --name <container name><image name>:**run a container from an image.

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.001.png)


**docker run -d --name <container name><image name>:**run a container in detached mode.

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.002.png)

**docker run -d -p  <port on host>:<port on container> --name <container name><image name>:**run a container with ports

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.003.png)

**docker ps:**List all running containers

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.004.png)

**docker ps -a:**List all containers,including stopped ones.

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.005.png)

**docker stop <container name>:**stop a running container.

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.006.png)

**docker start<container name>:**start a stopped container

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.007.png)

**docker rm <container name>:**remove a stopped container

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.008.png)

**docker restart <container name>:**restart a running container

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.009.png)

**docker exec -it <container><command>:**Execute a command inside a running container.

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.010.png)

**docker logs <container name>:**view logs a container

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.011.png)

**docker inspect <container name>:**Get detailed information about a container.

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.012.png)

**Docker images**

**docker pull image name:**Download a image from registry

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.013.png)

**docker images:**	List all downloaded images

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.014.png)

**System management**

**docker system df:**show docker disk usage

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.015.png)

**docker stats :**Display realtime sats of runing containers.

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.016.png)

**docker info:**Display docker system-wide information

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.017.png)

**Create a Docker file**

**Step1:**Create a index.html file

`            `mkdir ranjitha  \_\_ cd ranjitha \_\_ sudo vi index.html

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.018.png)

**Step2:**Create a Dockerfile

`           `sudo vi Dockerfile

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.019.png)

**Step3:**Build Docker image

`               `Run the following command in the directory containing your Dockerfile.

`               `docker build -t my-nginx-image .

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.020.png)

**Step4:**Run Custom NGINX Container
`           `Start a container from your custom image
**
`           `docker run --name my-custom-nginx1 -p 8082:80 -d my-nginx-             	   image

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.021.png)


**Step5:Check web server** 

`           `localhost:8082


![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.022.png)

**Networks**

**docker network ls:**List all docker networks 

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.023.png)

**docker exec -it <container1>/bin/bash:**logging into the container1

`     `Check networks and ip address of container1

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.024.png)

**docker exec -it <container2>/bin/bash:**Logging into container2

`       `Check networks and ip address of container2

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.025.png)

` `**docker exex -it <container1>/bin/bash:**ping container2 ip address** within the container1

![](Aspose.Words.537962d7-87ca-4eb7-8f4a-7c70a9c39d5d.026.png)
