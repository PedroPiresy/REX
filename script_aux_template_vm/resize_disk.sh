#!/bin/bash
growpart /dev/sda 1
resize2fs /dev/sda1

# Verificar se a partição /dev/vda existe
if [ -e /dev/vda ]; then
    echo "Detectado segundo disco em /dev/vda."

    # Criar o ponto de montagem /alterar, caso não exista
    if [ ! -d /alterar ]; then
        echo "Criando o diretório /alterar para o segundo disco..."
        mkdir /alterar
    fi

    # Criar o sistema de arquivos no segundo disco (caso ainda não tenha)
    if ! blkid /dev/vda; then
        echo "Formatando /dev/vda como ext4..."
        mkfs.ext4 /dev/vda
    else
        echo "O disco /dev/vda já possui um sistema de arquivos."
    fi

    # Montar a partição /dev/vda em /alterar
    echo "Montando /dev/vda em /alterar..."
    mount /dev/vda /alterar

    # Adicionar a partição /dev/vda na fstab para montagem automática
    if ! grep -q "/dev/vda" /etc/fstab; then
        echo "/dev/vda  /alterar  ext4  defaults  0  2" >> /etc/fstab
        echo "Entrada adicionada ao /etc/fstab."
    else
        echo "A entrada para /dev/vda já existe no /etc/fstab."
    fi
else
    echo "Segundo disco (/dev/vda) não detectado. Nenhuma ação necessária."
fi
