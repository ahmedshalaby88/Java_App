FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy the JAR file from target directory
COPY target/*.jar app.jar

# Expose port 8080
EXPOSE 8080

# Set the entry point
ENTRYPOINT ["java", "-jar", "app.jar"]
