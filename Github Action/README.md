# GitHub Action

GitHub Actions is a continuous integration and continuous delivery (CI/CD) platform that allows you to automate your build, test, and deployment pipeline.

### Continuous Integration (CI)
CI covers the build and test stages of the pipeline. Each change in code should trigger an automated build and test, allowing the developer of the code to get quick feedback.

### Continuous Delivery / Deployment (CD)
The CD part of a CI/CD pipeline refers to Delivery and Deployment (CI/CDD anyone?!). CD takes place after the code successfully passes the testing stage of the pipeline. Continuous delivery refers to the automatic release to a repository after the CI stage. Continuous deployment refers to the automatic deployment of the artifact that has been delivered.

![image](https://github.com/user-attachments/assets/8df069e8-f9ef-48bf-afeb-34d0930c701e)




- The CI phase consists of the following stages:
      Build ,
      Unit Tests,
      Integration Tests
- The CD phase consists of the following stages:
      Release,
      Deploy,
      Operate

### Set Up GitHub Secrets

GitHub Actions will need access to your Docker Hub account. To avoid hardcoding credentials, we will store them as GitHub secrets.

Go to your GitHub repository and navigate to Settings > Secrets and variables > Actions > New repository secret.Add the following details.

### Create the following secrets:

DOCKERHUB_USERNAME: DockerHub username.(ranjithalogesh)

DOCKERHUB_TOKEN: A personal access token from Docker Hub (You can create this in Docker Hub under Account Settings > Security).or

DOCKERHUB_PASSWORD: Dockerhub password(tharshik123)



