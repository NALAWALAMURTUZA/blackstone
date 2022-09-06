# https://hub.docker.com/r/google/dart/
FROM google/dart

# Working directory with the source in the container
WORKDIR /app

## Copy the source and download the dependencies
ADD ./dist/pubspec.* /app/
RUN flutter pub get
ADD ./dist /app
RUN flutter pub get --offline

# Start the Dart web server
ENTRYPOINT ["/usr/bin/dart", "/app/lib/main.dart"]

# Expose the port that App Engine Flex will point to
EXPOSE 8080
