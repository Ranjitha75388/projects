```
#!/bin/bash

# Variables
GIT_REPO="https://github.com/Ranjitha75388/ranjitha_assesment"
APP_DIR="/home/ranjitha/ranjitha_assesment"
SPRING_BOOT_DIR="$APP_DIR/ems-ops-phase/springboot-backend"  # Adjust path if needed
JAVA_VERSION="11"  # Change to your desired Java version


# Update system packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install Java Development Kit (JDK)
echo "Installing OpenJDK $JAVA_VERSION..."
sudo apt -y install openjdk-$JAVA_VERSION-jdk
java -version

# Clone the backend application from GitHub (if not already cloned)
echo "Cloning backend repository..."
if [ ! -d "$SPRING_BOOT_DIR" ]; then
    git clone --depth 1 $GIT_REPO $APP_DIR
else
    echo "$SPRING_BOOT_DIR already exists. Skipping clone."
fi

# Check if Spring Boot directory exists and contains pom.xml
if [ ! -d "$SPRING_BOOT_DIR" ] || [ ! -f "$SPRING_BOOT_DIR/pom.xml" ]; then
    echo "Error: Spring Boot directory or pom.xml not found. Exiting."
    exit 1
fi

# Navigate to Spring Boot backend directory
cd $SPRING_BOOT_DIR

# Install dependencies with Maven
echo "Building Spring Boot application using Maven..."
mvn clean install -DskipTests

# Check if the JAR file exists in the target directory
JAR_FILE=$(find target -name "*.jar" -print -quit)

if [ -z "$JAR_FILE" ]; then
    echo "Error: No JAR file found in the target directory. Exiting."
    exit 1
fi

# Run the Spring Boot application JAR file
echo "Running the Spring Boot application from JAR file..."
java -jar $JAR_FILE

echo "Spring Boot backend setup completed successfully!"
```
