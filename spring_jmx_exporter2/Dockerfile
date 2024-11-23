
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

FROM tomcat:9.0-jdk17

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080 9090

ENV CATALINA_OPTS="-javaagent:/usr/local/tomcat/jmx_prometheus_javaagent.jar=9090:/usr/local/tomcat/config.yml"

ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.18.0/jmx_prometheus_javaagent-0.18.0.jar /usr/local/tomcat/jmx_prometheus_javaagent.jar

COPY config.yml /usr/local/tomcat/config.yml

CMD ["catalina.sh", "run"]