FROM maven:latest AS builder
WORKDIR /opt/app
COPY . .
RUN mvn clean package

FROM ibm-semeru-runtimes:open-8-jdk-focal
COPY --from=builder /opt/app/target/parksmap-web.jar /parksmap.jar
CMD java -jar /parksmap.jar
EXPOSE 8080
