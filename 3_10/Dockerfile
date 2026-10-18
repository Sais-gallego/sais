FROM eclipse-temurin:8-jdk-alpine AS build-stage

WORKDIR /usr/src/app

COPY . .

RUN chmod +x mvnw && ./mvnw package -DskipTests

FROM eclipse-temurin:8-jre-alpine

WORKDIR /usr/src/app

RUN adduser -D appuser && chown -R appuser /usr/src/app

COPY --from=build-stage --chown=appuser:appuser /usr/src/app/target/docker-example-1.1.3.jar ./app.jar

USER appuser

EXPOSE 8080

CMD ["java", "-jar", "./app.jar"]
