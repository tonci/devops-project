# DevOps final project

The project so far consist of a simple java (Spring Boot application) that serves as an API server.

The code for the API server is located in the `api` folder. It contains a `Dockerfile` that builds the image for the API server based on `openjdk:21-ea-34-slim` image.

Currently it has a pipeline on the push to `main` branch that builds the image and pushes it to the docker hub at [tonci123/devops-java-api](https://hub.docker.com/r/tonci123/devops-java-api).