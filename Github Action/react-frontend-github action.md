# React frontend github action

Step1: cd ranjitha/Jumisa technology

Step2: touch Dockerfile

Step3: nano Dockerfile

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
Step4: cd .github/workflows

Step5: touch docker-publish.yml

Step6: nano docker-publish.yml

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
          docker push ${{ secrets.DOCKERHUB_USERNAME }}/my-react-app:latest

```

Step7: git add .

Step8: git commit -m "Added react yml"

Step9: git push origin main

Step10: check github Action.

   Added react yml workflow starts running
   
   ![Screenshot from 2024-12-04 22-46-25](https://github.com/user-attachments/assets/967ec3ad-f3c1-469b-b2c8-030456a084ad)

   
  
   After process completed image added in dockkerhub account.
   
   ![Screenshot from 2024-12-04 22-52-27](https://github.com/user-attachments/assets/4d8a4a36-8c0d-47f7-bc71-c0dda9e07720)



