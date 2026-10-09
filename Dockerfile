FROM eclipse-temurin:21-jdk-alpine AS builder
WORKDIR /workspace
COPY code/pom.xml code/mvnw code/mvnw.cmd ./
COPY code/.mvn .mvn
COPY code/src src
RUN chmod +x mvnw && ./mvnw package -Dmaven.test.skip=true
FROM eclipse-temurin:21-jre-alpine
RUN apk add --no-cache nodejs && addgroup -S spring && adduser -S spring -G spring
WORKDIR /app
COPY --from=builder /workspace/target/*.jar app.jar
COPY code/server.js code/cloudflare-turn.js code/turn-config.js code/turn-check.html code/container-start.sh ./
RUN chmod +x container-start.sh
USER spring:spring
ENV SPRING_PROFILES_ACTIVE=container SERVER_PORT=8080 PORT=3000 HOST=0.0.0.0 BACKEND_URL=http://127.0.0.1:8080
EXPOSE 3000
ENTRYPOINT ["/bin/sh","/app/container-start.sh"]
