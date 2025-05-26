# React frontend 

### Step 1:change to github repo named as github-actions 
```
  cd ranjitha/github-actions
 ```
### Step 2: create react-hooks-frontend folder from ranjitha/github-actions
```
cd ranjitha/github-actions/react-hooks-frontend
```
### Step 3:Copy reacthooks files given by team from local machine to Github directory
```
 cp -r /home/logi/Downloads/old-files/ems-ops-phase-0/react-hooks-frontend .
```
   
### Step 4:create Dockerfile 
nano Dockerfile
```bash  

# Use the official Node.js image as a base
FROM node:14

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code to the working directory
COPY . .

# Expose port 3000 for the application
EXPOSE 3000

# Command to run the application
CMD ["npm", "start"]

```
### Step 5 : create workflow file from ranjitha/github-actions

cd .github/workflows

touch docker-publish.yml

nano docker-publish.yml

```bash
name: Build and Push Docker Image

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      # Step 1: Checkout code from the repository
      - name: Checkout code
        uses: actions/checkout@v3

      # Step 2: Set up Docker
      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      # Step 3: Log in to Docker Hub
      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      # Step 4: Build the Docker image
      - name: Build the Docker image
        run: |
          docker build -t ${{ secrets.DOCKERHUB_USERNAME }}/my-react-app:latest .

      # Step 5: Push the Docker image to Docker Hub
      - name: Push the Docker image
        run: |
          docker push ${{ secrets.DOCKERHUB_USERNAME }}/front-app:latest

```
### Step 6 : Add to github account

git add .

git commit -m "Added react yml"

git push origin main

### Step 7 : check Actions in github account.

   Added react yml workflow starts running
   
   ![Screenshot from 2024-12-04 22-46-25](https://github.com/user-attachments/assets/967ec3ad-f3c1-469b-b2c8-030456a084ad)

 ### Step 9 :Image added in dockerhub account  
  
   After process completed image added in dockerhub account.
   
  ![Screenshot from 2024-12-22 16-14-01](https://github.com/user-attachments/assets/68147456-787b-49b9-b90f-f8c8428a346f)


### Step10 :create a container

create a docker container and pull the docker image from dockerhub created above 
 ```
    docker run -d --name react1 -p 3001:3000 ranjithalogesh/my-react-app
```
### Step11:check localhost:3011

![Screenshot from 2024-12-12 22-27-40](https://github.com/user-attachments/assets/a0cca9cc-4f2a-41fb-b4d2-c6e42479d612)

