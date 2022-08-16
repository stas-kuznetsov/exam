FROM openjdk:11-jdk-alpine
ARG JAR_FILE=app1.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
