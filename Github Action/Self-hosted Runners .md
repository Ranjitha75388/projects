
# Self-hosted runner

- Self-hosted runners are applications that allow users to run jobs from CI/CD workflows on their own infrastructure rather than relying on cloud-hosted solutions. 
- This setup is particularly advantageous for projects with specific hardware, software, or security requirements.
- The main difference between self-hosted and cloud-hosted applications is who runs and maintains them: 
  ### Self-hosted
  You run and maintain your own applications, data, sites, or services on a   private server. This is also known as on-premises or local hosting. You're responsible for installing, maintaining, backing up, and securing the data.

  ### Cloud-hosted
  A third party, often a SaaS (Subscription as a Service) vendor, runs and maintains your applications. You pay a subscription fee for the service, which includes the application, maintenance, and storage.

### Setup self-hosted runner

- Githubrepo(github-actions) -> settings -> Actions -> runner
- Click the runner image (linux)
- Architecture (x64)
- Follow the Downloads and configure step by steps in terminal

![Screenshot from 2024-12-22 17-08-13](https://github.com/user-attachments/assets/535603bf-a3fb-4f2a-a21e-feee2280dff7)



### check in runners

![Screenshot from 2024-12-22 17-19-40](https://github.com/user-attachments/assets/50278c42-25b7-4310-98c9-402d622a0631)


### Run the workflow file
``` 
name: Build and Push Docker Frontend Image

on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: self-hosted

    steps:
      # Step 1: Checkout code from the repository
      - name: Checkout code
        uses: actions/checkout@v3

      # Step 2: Set up Node.js
      - name: Set up Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '14'  # Specify the Node.js version you want to use

      # Step 3: Install Dependencies
      - name: Install Dependencies
        run: |
          cd react-hooks-frontend
          npm install
      # Optional: List files to verify contents (for debugging)
      - name: List the files
        run: |
          cd react-hooks-frontend
          ls
      # Step 4: Log in to Docker Hub
      - name: Log in to Docker Hub
        uses: docker/login-action@v1
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}


      # Step 4: Build and push the Docker image using Buildx
      - name: Build and Push the Docker image
        uses: docker/build-push-action@v4  # Use the official build-push-action
        with:
          context: ./react-hooks-frontend  # Set the context to the directory containing the Dockerfile
          file: ./react-hooks-frontend/Dockerfile  # Specify the Dockerfile location
          push: true  # Push the image to Docker Hub after building
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/front-app:latest
```
### Listening for jobs
Also in terminal the status willbe shown

![Screenshot from 2024-12-22 17-18-20](https://github.com/user-attachments/assets/fa07cd0e-da35-4ecb-ae9f-5e59cd4590ca)





