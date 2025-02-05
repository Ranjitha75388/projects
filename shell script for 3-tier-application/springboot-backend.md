```
#!/bin/bash

# Variables
GIT_REPO="https://github.com/Ranjitha75388/ranjitha_assesment"     ### if public repo
# GIT_REPO="git@github.com:Ranjitha75388/ranjitha_assesment.git"   ### if private repo
APP_DIR="/home/ranjitha/ranjitha_assesment"
SPRING_BOOT_DIR="$APP_DIR/ems-ops-phase/springboot-backend"
JAVA_VERSION="11"


# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Java Development Kit (JDK)
echo "Installing OpenJDK $JAVA_VERSION..."
sudo apt -y install openjdk-$JAVA_VERSION-jdk
java -version

# Clone the backend application from GitHub (if not already cloned)
echo "Cloning backend repository..."
git clone --depth 1 $GIT_REPO $APP_DIR

# Navigate to Spring Boot backend directory
cd $SPRING_BOOT_DIR

# Install dependencies with Maven
echo "Building Spring Boot application using Maven..."
mvn clean install -DskipTests


# Check if the JAR file exists in the target directory
JAR_FILE=$(find target -name "*.jar" -print -quit)

# Run the Spring Boot application JAR file
echo "Running the Spring Boot application from JAR file..."
java -jar $JAR_FILE

echo "Spring Boot backend setup completed successfully!"
```


- ### Change the application properties manually.
# ERROR:
while running springboot application the error like :**Connections using insecure transport are prohibited (require_secure_transport=ON)**

**soln**:Your Azure MySQL Flexible Server requires SSL/TLS encryption, but your Spring Boot app is not using SSL.

Step1:Download the Azure MySQL SSL Certificate
```
wget https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt.pem -O /home/ranjitha/mysql-azure-cert.pem
```
Step2:Update application.properties
```
spring.datasource.url=jdbc:mysql://mysql-db-demo.mysql.database.azure.com:3306/new_flexible_db?useSSL=true&requireSSL=true&trustCertificateKeyStoreUrl=file:/home/ranjitha/mysql-azure-cert.pem&serverTimezone=UTC
spring.datasource.username=ranjitha
spring.datasource.password=tharshik@123
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.hibernate.ddl-auto=update
```
