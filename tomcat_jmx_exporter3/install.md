### Install Java JDK e Maven
sudo apt install zip -y
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk version

### Install Maven
sdk install maven 3.8.5 -y
mvn --version

### Install JDK
sdk install java 17.0.12-oracle -y
java --version

### Install Tomcat
sudo useradd -m -U -d /opt/tomcat -s /bin/false tomcat

wget https://downloads.apache.org/tomcat/tomcat-10/v10.1.33/bin/apache-tomcat-10.1.33.tar.gz
sudo mkdir /opt/tomcat
sudo tar -xzf apache-tomcat-10.1.33.tar.gz -C /opt/tomcat --strip-components=1

