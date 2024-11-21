
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2: Runtime
FROM tomcat:9.0-jdk17

# Remover o aplicativo padrão do Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiando o arquivo WAR para o diretório webapps do Tomcat
COPY --from=build /app/target/ROOT.war /usr/local/tomcat/webapps/ROOT.war

# Expondo a porta da aplicação e a porta do JMX para exportação de métricas
EXPOSE 8080 9090

# Configurando o Java Agent do Prometheus para expor métricas em /metrics
ENV CATALINA_OPTS="-javaagent:/usr/local/tomcat/jmx_prometheus_javaagent.jar=9090:/usr/local/tomcat/config.yml"

# Baixando o JMX Prometheus Java Agent
ADD https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.18.0/jmx_prometheus_javaagent-0.18.0.jar /usr/local/tomcat/jmx_prometheus_javaagent.jar

# Adicionando arquivo de configuração do JMX Prometheus
COPY config.yml /usr/local/tomcat/config.yml

# Iniciando o Tomcat
CMD ["catalina.sh", "run"]