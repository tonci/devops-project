FROM openjdk:21-ea-34-slim

RUN useradd -m appuser
WORKDIR /app

RUN chown -R appuser:appuser /app

USER appuser

COPY target/app.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]