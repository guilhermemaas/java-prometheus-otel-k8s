#cloud-config
write_files:
  - path: /root/init-script.sh
    content: |
      #!/bin/bash

      # Atualizar lista de pacotes e instalar zip e curl
      apt-get update
      apt-get install -y zip curl

      # Instalar SDKMAN
      curl -s "https://get.sdkman.io" | bash
      source "$HOME/.sdkman/bin/sdkman-init.sh"

      # Instalar Maven e JDK usando SDKMAN
      sdk install maven 3.8.5
      sdk install java 17.0.12-oracle

      # Verificar versões do Maven e JDK
      mvn --version
      java --version

      mkdir /etc/testezera

runcmd:
  - chmod +x /root/init-script.sh
  - /root/init-script.sh