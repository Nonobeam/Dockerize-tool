FROM openjdk:17-jdk-slim

## Name of build file
ARG built_file
ENV BUILT_FILE=$built_file
ARG port
ENV PORT=$port

WORKDIR /app

## Copy the built JAR file to the final location
COPY build-in/target/${BUILT_FILE} /app/${BUILT_FILE}

# Expose the port on which the Spring Boot application will run
EXPOSE ${PORT}

# Run the application
ENTRYPOINT ["sh", "-c", "java -jar /app/${BUILT_FILE}"]