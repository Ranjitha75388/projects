
# springboot backend

### Step 1: create folder springboot-backend
```
   cd ranjitha/github-actions/springboot-backend
```  
### Step 2: copy backend files from local machine to github repo
```
 cp -r ranjitha/github-actions/springboot-backend/home/logi/Downloads/old-files/ems-ops-phase-0/springboot-backend .
 ```
Step 3 :touch Dockerfile in springboot-backend directory

Step 4: nano Dockerfile
```
FROM openjdk:17-jdk-slim

WORKDIR /app

COPY target/springboot-backend-0.0.1-SNAPSHOT.jar /app/springboot-backend-0.0.1-SNAPSHOT.jar


ENTRYPOINT ["java", "-jar", "springboot-backend-0.0.1-SNAPSHOT.jar"]
```
### Step 5 :create workflow file from ranjitha/github-actions

cd .github/workflows

nano build and push spring-boot.yml
```
name: Build and Push Spring Boot Image

on:
  push:
    branches:
      - feature

jobs:
  build:
    runs-on: ubuntu-latest

    services:
      database:
        image: mysql:8
        env:
          MYSQL_DATABASE: mynewdatabase
          MYSQL_USER: ranjitha
          MYSQL_PASSWORD: ranjitha
          MYSQL_ROOT_PASSWORD: ranjitha
        ports:
          - "3306:3306"

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Buildx
        uses: docker/setup-buildx-action@v2

      - name: Set up JDK 17
        uses: actions/setup-java@v3
        with:
          distribution: 'temurin'
          java-version: '17'

      - name: Log in to Docker Hub
        uses: docker/login-action@v2
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

 - name: Build the application
        run: mvn clean package --file "./springboot-backend/pom.xml"

      - name: Run Tests
        run: mvn test --file "./springboot-backend/pom.xml"

      - name: Build and push Docker image
        uses: docker/build-push-action@v4
        with:
          context: ./springboot-backend  # Set the context to the directory containing the Dockerfile
          file: ./springboot-backend/Dockerfile  # Specify the Dockerfile location
          push: true  # Push the image to Docker Hub after building
          tags: ${{ secrets.DOCKERHUB_USERNAME }}/my-spring-bootapp:latest


      - name: Wait for MySQL to be ready
        run: |
          echo "Waiting for MySQL to be ready..."
          for i in {1..30}; do
            if nc -z database 3306; then
              echo "MySQL is up!"
              break
            fi
            echo "Waiting for MySQL..."
            sleep 5
          done

```
### Step 6: Add to github and run the yml file

git add .

git commit -m "app"

git push origin feature

### Step 7:check Actions in github repo
build and push springboot- backend.yml start running

![Screenshot from 2024-12-22 16-07-32](https://github.com/user-attachments/assets/306eee60-cd13-435d-a1b0-257d2988f2dc)



### Step 8:Image added in dockerhub account
 my-springboot-app image added in dockerhub account

![Screenshot from 2024-12-22 16-14-01](https://github.com/user-attachments/assets/d0ef4959-9ec7-49bb-b6b7-902171c3d197)



### Step 9:Create docker container with springboot image
```
docker run -d --name spring1 -p 8082:8080 ranjithalogesh/my-springboot-app
```










