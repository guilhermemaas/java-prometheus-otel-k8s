FROM maven:3.8.5-openjdk-17 AS build

WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests
RUN ls /app/target/

FROM tomcat:10.1-jdk17

# Defina o diretório de trabalho no Tomcat
WORKDIR /usr/local/tomcat

# Copie o artefato WAR da fase de build
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war
RUN ls /usr/local/tomcat/webapps/
RUN chmod 644 /usr/local/tomcat/webapps/ROOT.war

# Copie o jmx_prometheus_javaagent.jar e o arquivo de configuração jmx_exporter_config.yaml para o diretório de lib do Tomcat
COPY ./tomcat-config/jmx_prometheus_javaagent-0.16.1.jar /usr/local/tomcat/lib/jmx_prometheus_javaagent.jar
COPY ./tomcat-config/jmx_exporter_config.yaml /usr/local/tomcat/lib/jmx_exporter_config.yaml

# Copie o setenv.sh para o diretório bin do Tomcat
COPY ./tomcat-config/setenv.sh /usr/local/tomcat/bin/setenv.sh
RUN chmod +x /usr/local/tomcat/bin/setenv.sh

# Exponha as portas necessárias
EXPOSE 8080 1099

# Comando para iniciar o Tomcat
CMD ["catalina.sh", "run"]
