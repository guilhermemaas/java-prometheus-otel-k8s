FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests
RUN ls /app/target/

FROM tomcat:10.1-jdk17

WORKDIR /usr/local/tomcat

COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
RUN ls /usr/local/tomcat/webapps/
RUN chmod 644 /usr/local/tomcat/webapps/ROOT.war

COPY ./tomcat-config/jmx_prometheus_javaagent-0.16.1.jar /usr/local/tomcat/lib/jmx_prometheus_javaagent.jar
COPY ./tomcat-config/jmx_exporter_config.yaml /usr/local/tomcat/lib/jmx_exporter_config.yaml

COPY ./tomcat-config/setenv.sh /usr/local/tomcat/bin/setenv.sh
RUN chmod +x /usr/local/tomcat/bin/setenv.sh

EXPOSE 8080 1099

CMD ["catalina.sh", "run"]
