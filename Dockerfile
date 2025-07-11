# Use lightweight JDK image
FROM openjdk:8-alpine

# Install bash (optional for troubleshooting)
RUN apk update && apk add --no-cache bash

# Create app directory
WORKDIR /opt/app

# Copy built jar
COPY target/spring-boot-mongo-1.0.jar spring-boot-mongo.jar

# Expose port
EXPOSE 8080

# Run app
ENTRYPOINT ["java","-jar","spring-boot-mongo.jar"]

