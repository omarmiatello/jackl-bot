# https://hub.docker.com/_/gradle -- Use the official gradle image to create a build artifact.
FROM gradle as builder

# Copy local code to the container image.
COPY build.gradle.kts gradle.properties ./
COPY src ./src

# Build a release artifact.
RUN gradle clean build --no-daemon

# https://docs.docker.com/develop/develop-images/multistage-build/#use-multi-stage-builds
# https://hub.docker.com/_/openjdk -- Use the Official OpenJDK image for a lean production stage of our multi-stage build.
FROM openjdk:8-jre-alpine

# Copy the jar to the production image from the builder stage.
COPY --from=builder /home/gradle/build/libs/app-all.jar .

# Run the web service on container startup.
CMD [ "java", "-jar", "-Djava.security.egd=file:/dev/./urandom", "/app-all.jar" ]