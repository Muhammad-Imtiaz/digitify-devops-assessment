# Official OpenJDK runtime as Base Image
FROM openjdk:17-jdk-alpine

# Setting WORKDIR
WORKDIR /app

# Copy the project's jar file into the container
COPY target/*.jar app.jar

# Exposing the port
EXPOSE 8080

# Run the jar file
ENTRYPOINT ["java", "-jar", "app.jar"]