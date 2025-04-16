FROM openjdk:21-jdk-slim as builder
WORKDIR workspace
ARG JAR_FILE=target/catalog-service-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} catalog-service.jar
RUN java -Djarmode=layertools -jar catalog-service.jar extract

FROM openjdk:21-jdk-slim
RUN useradd spring
WORKDIR workspace
COPY --from=builder workspace/dependencies/ ./
COPY --from=builder workspace/spring-boot-loader/ ./
COPY --from=builder workspace/snapshot-dependencies/ ./
COPY --from=builder workspace/application/ ./
ENTRYPOINT ["java", "org.springframework.boot.loader.JarLauncher"]