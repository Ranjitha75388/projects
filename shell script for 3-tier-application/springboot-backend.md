# Shell script for spring-boot application cloning private repo and running as a service

```
#!/bin/bash

# Variables
GIT_REPO="https://Ranjitha75388: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@github.com/Ranjitha75388/ranjitha_assesment.git"     ##### https method
# GIT_REPO="git@github.com:Ranjitha75388/ranjitha_assesment.git"      ####### ssh method
APP_DIR="/home/ranjitha/ranjitha_assesment"
SPRING_BOOT_DIR="$APP_DIR/ems-ops-phase/springboot-backend"
JAVA_VERSION="17"
MAVEN_VERSION="3.8.8"
DB_URL="jdbc:mysql://mysql-server-demo.mysql.database.azure.com:3306/new_flexible_db?useSSL=true&requireSSL=true&verifyServerCertificate=true"
DB_USERNAME="ranjitha"
DB_PASSWORD="tharshik@123"

# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Java Development Kit (JDK)
echo "Installing OpenJDK $JAVA_VERSION..."
sudo apt -y install openjdk-$JAVA_VERSION-jdk
java -version

# Install Apache Maven
echo "Installing Apache Maven $MAVEN_VERSION..."
cd /opt
sudo wget https://dlcdn.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
sudo tar -xvzf apache-maven-$MAVEN_VERSION-bin.tar.gz
sudo mv apache-maven-$MAVEN_VERSION apache-maven
sudo rm apache-maven-$MAVEN_VERSION-bin.tar.gz

# Set environment variables for Maven
echo "Setting up Maven environment variables..."
export M2_HOME=/opt/apache-maven
export PATH=$M2_HOME/bin:$PATH

# Verify Maven installation
mvn -version

# Clone the backend application from GitHub (if not already cloned)
echo "Cloning backend repository..."
git clone --depth 1 $GIT_REPO $APP_DIR

# Navigate to Spring Boot backend directory
cd $SPRING_BOOT_DIR

# Update application.properties with database details
echo "Configuring database connection..."
cat <<EOL > src/main/resources/application.properties
spring.datasource.url=$DB_URL
spring.datasource.username=$DB_USERNAME
spring.datasource.password=$DB_PASSWORD
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQLDialect
spring.jpa.hibernate.ddl-auto=update
EOL

# Install dependencies with Maven
echo "Building Spring Boot application using Maven..."
mvn clean install -DskipTests

# Check if the JAR file exists in the target directory
JAR_FILE=$(find target -name "*.jar" -print -quit)

if [ -z "$JAR_FILE" ]; then
  echo "Error: JAR file not found in target directory."
  exit 1
fi

# Run the Spring Boot application JAR file
echo "Running the Spring Boot application from JAR file..."
java -jar $JAR_FILE

echo "Spring Boot backend setup completed successfully!"

# Create a systemd service file for the application
echo "Creating systemd service file..."
sudo bash -c "cat > /etc/systemd/system/springboot-backend.service" <<EOL
[Unit]
Description=Spring Boot Backend Application
After=network.target

[Service]
User=ranjitha
ExecStart=/usr/bin/java -jar $SPRING_BOOT_DIR/$JAR_FILE
SuccessExitStatus=143
Restart=on-failure
RestartSec=10
Environment=SPRING_PROFILES_ACTIVE=prod

[Install]
WantedBy=multi-user.target
EOL
# Reload systemd to apply the new service
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

# Enable and start the service
echo "Enabling and starting the springboot-backend service..."
sudo systemctl enable springboot-backend
sudo systemctl start springboot-backend

echo "Spring Boot backend setup and service configuration completed successfully!"

```
