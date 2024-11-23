#!/bin/bash

# Registrar saída em log
mkdir -p /var/log/haproxy_exporter && sudo sh -c 'echo "Iniciando script" > /var/log/haproxy_exporter/haproxy_exporter_install.log'
set -e

# Atualizar pacotes do sistema
apt-get update -y

# Instalar HAProxy
apt-get install -y haproxy

# Configurar HAProxy para expor estatísticas
tee -a /etc/haproxy/haproxy.cfg > /dev/null <<EOL

listen stats
    bind *:8404
    mode http
    stats enable
    stats uri /stats
    stats refresh 10s
EOL

# Reiniciar HAProxy para aplicar as alterações
systemctl restart haproxy

# Baixar e instalar o HAProxy Exporter para Prometheus
wget https://github.com/prometheus/haproxy_exporter/releases/download/v0.13.0/haproxy_exporter-0.13.0.linux-amd64.tar.gz
tar xzf haproxy_exporter-0.13.0.linux-amd64.tar.gz
mv haproxy_exporter-0.13.0.linux-amd64/haproxy_exporter /usr/local/bin/

# Remover arquivos desnecessários
rm -rf haproxy_exporter-0.13.0.linux-amd64.tar.gz haproxy_exporter-0.13.0.linux-amd64

# Criar um serviço systemd para o HAProxy Exporter
tee /etc/systemd/system/haproxy_exporter.service > /dev/null <<EOL
[Unit]
Description=Prometheus HAProxy Exporter
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/haproxy_exporter \
  --haproxy.scrape-uri="http://localhost:8404/stats;csv"
Restart=always

[Install]
WantedBy=multi-user.target
EOL

# Carregar e iniciar o serviço do HAProxy Exporter
systemctl daemon-reload
systemctl enable haproxy_exporter
systemctl start haproxy_exporter

# Registrar saída em log
sudo sh -c 'echo "HAProxy e Prometheus Exporter instalados e rodando com sucesso." >> /var/log/haproxy_exporter/haproxy_exporter_install.log'