# Exercise 3.10: Optimizing a Standalone Dockerfile (Spring Example Project)

For this exercise, I optimized the Spring Boot Java application `Dockerfile` from Exercise 1.11 using:
1. **Multi-stage build** (`eclipse-temurin:8-jdk-alpine` for building the JAR, and `eclipse-temurin:8-jre-alpine` for running it, dropping the JDK and Maven wrapper/cache from the final image).
2. **Non-root user** (`appuser`) for runtime security.
3. **Combined `RUN` layers**.

## Size Comparison
- **Before (`Dockerfile.before`)**: `668 MB`
- **After (`Dockerfile`)**: `108 MB`

## `Dockerfile.before` (668 MB)
```dockerfile
FROM eclipse-temurin:8-jdk

WORKDIR /usr/src/app

COPY . .

RUN chmod +x mvnw
RUN ./mvnw package

EXPOSE 8080

CMD ["java", "-jar", "./target/docker-example-1.1.3.jar"]
```

## `Dockerfile` After Optimization (108 MB)
```dockerfile
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
```
