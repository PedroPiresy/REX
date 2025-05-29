#!/bin/bash
# Script para configuração automática de hosts em ambiente oVirt
# Este script realiza as seguintes operações:
# 1. Verifica conectividade de rede
# 2. Obtém informações da VM através da API do oVirt
# 3. Configura o hostname do sistema


# Configuração de log
LOGFILE="/var/log/configure_host.log"
exec > >(tee -a $LOGFILE) 2>&1

echo "Iniciando script de configuração do host em $(date)"

# Configurações da API do oVirt
# Substitua estas variáveis com suas credenciais reais
OVIRT_API_URL="https://seu-ovirt-engine/ovirt-engine/api"
OVIRT_USER="seu_usuario@internal"
OVIRT_PASS="sua_senha"

# Aguardar conectividade de rede
echo "Aguardando rede estar disponível..."
RETRIES=10
# Verifica conectividade de rede usando o gateway padrão
while ! ip route | grep -q "default"; do
    RETRIES=$((RETRIES - 1))
    if [ $RETRIES -le 0 ]; then
        echo "Erro: Rede não disponível após várias tentativas."
        exit 1
    fi
    echo "Aguardando configuração de rede... Tentativas restantes: $RETRIES"
    sleep 5
done

# Obter o ID da VM do sistema local
# O UUID da VM é usado para identificação única no oVirt
VM_ID=$(cat /sys/class/dmi/id/product_uuid)
if [ -z "$VM_ID" ]; then
    echo "Erro: Não foi possível obter o ID da VM."
    exit 1
fi
echo "ID da VM local: $VM_ID"

# Consultar a API do oVirt para obter informações da VM
# Utiliza o UUID para buscar detalhes da VM no oVirt
VM_INFO=$(curl -s -u "$OVIRT_USER:$OVIRT_PASS" -X GET -H "Accept: application/json" -k \
    "$OVIRT_API_URL/vms/$VM_ID")
if echo "$VM_INFO" | grep -q '"name"'; then
    VM_NAME=$(echo "$VM_INFO" | jq -r '.name')
else
    echo "Erro: Não foi possível obter o nome da VM."
    exit 1
fi

if [ -z "$VM_NAME" ]; then
    echo "Erro: Nome da VM está vazio."
    exit 1
fi
echo "Nome da VM obtido: $VM_NAME"

# Configurar o hostname temporariamente (em tempo de execução)
hostname "$VM_NAME" && echo "Hostname temporário configurado para $VM_NAME"

# Configurar o hostname permanentemente
hostnamectl set-hostname "$VM_NAME" && echo "Hostname permanente configurado para $VM_NAME"

# Atualizar /etc/hosts com o novo hostname
if grep -q "127.0.1.1" /etc/hosts; then
    sed -i "s/127.0.1.1.*/127.0.1.1   $VM_NAME/" /etc/hosts
else
    echo "127.0.1.1   $VM_NAME" >> /etc/hosts
fi