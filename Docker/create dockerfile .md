# Create a Dockerfile

**Dockerfile** is a textfile that contains set of instructions for creating a container image.

**Step1:** Create a directory

Create a directory for your project where you will store your Dockerfile.
```
mkdir ranjitha ---> cd ranjitha
```
**Step2:** Create a index.html file

Create a index.html file in a current directory(ranjitha)

![image](https://github.com/user-attachments/assets/8a7a4c49-06e2-4576-80a7-4f3ed3b8c894)

**Step3:** Create the Dockerfile

Create an empty file named as **Dockerfile** (without any file extension)
```
touch Dockerfile
```
**Step4:** Open the Dockerfile in a Text Editor

Use your preferred text editor to open the Dockerfile.
```
Vi Dockerfile
```
![image](https://github.com/user-attachments/assets/4d25b3f1-88d9-4a5f-ad32-581a4d02b450)

- Base Image:**FROM nginx**

  This line specifies that you're using the latest nginx image as the base.

- Update Package Lists:  **RUN apt-get update**

  This updates the package lists for the APT package manager.

- Install Nginx:  **RUN apt-get install -y nginx**

  This installs Nginx in the container

- Copy HTML File:  **COPY index.html  /usr/share/nginx/html/index.html**

  This copies your local index.html file into the appropriate directory (/usr/share/nginx/html/index.html) for Nginx to serve.

- Expose Port 80:  **EXPOSE 80**

  This tells Docker to expose port 80, which is the default port for nginx.

- Run Nginx in Foreground:   **CMD ["nginx", "-g", "daemon off;"]**

  This command starts Nginx in the foreground, which is necessary for Docker containers to keep running.

**Step5:** Building and Running  Docker Image

### 1.Build Your Docker Image
Navigate to the directory containing your Dockerfile and run:
```
docker build -t nginx-latest .
```
The -t flag tags your image with a name (nginx-latest), and the . specifies that the current directory should be used as the build context.

![image](https://github.com/user-attachments/assets/dff630a7-4eb4-4be9-a933-8e3c005b85d0)

### 2.Check docker images
```
docker images
```
![image](https://github.com/user-attachments/assets/ec5ed2f9-06e9-4c9a-ba5b-4298acc8994b)


### 3.Run Your Container:

After building your image, you can run it using:
```
docker run -d -it –name nginxcon1 -p 8084:80 nginx-latest
```
This command runs your container in detached mode (**-d**), maps port **8084:80** and names it **nginxcon1** by using image **nginx-latest**.

![image](https://github.com/user-attachments/assets/4d550d98-00ba-4329-a99a-ee1d23395b27)


### 4.Access Your Application:
Open the web browser and go to localhost:8084 to see application running.

![image](https://github.com/user-attachments/assets/fa48ed1d-a37e-463b-9402-bc158487a190)


