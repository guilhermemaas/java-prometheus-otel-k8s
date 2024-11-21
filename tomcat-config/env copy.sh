#!/bin/sh

JAVA_OPTS="-Xms256m -Xmx512m -Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.port=1099 \
-Dcom.sun.management.jmxremote.rmi.port=1099 \
-Djava.rmi.server.hostname=localhost \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false \
-javaagent:/usr/local/tomcat/lib/jmx_prometheus_javaagent.jar=8081:/usr/local/tomcat/lib/jmx_exporter_config.yaml"