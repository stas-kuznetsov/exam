FROM openjdk:11-jdk-alpine
ARG JAR_FILE=/Jenkins/spring-petclinic/target/spring-petclinic-2.7.0-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]