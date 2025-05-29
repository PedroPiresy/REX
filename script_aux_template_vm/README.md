# README - Scripts de Configuração do Projeto RestIAC

Este repositório contém os scripts utilizados para realizar configurações automáticas em VMs criadas pelo projeto RestIAC. Estes scripts são executados automaticamente durante o boot das VMs e realizam ajustes no disco e no hostname, além de outras configurações relacionadas ao ambiente.

## Estrutura dos Arquivos

### 1. **resize_disk.sh**
Este script realiza a configuração do disco da VM, incluindo a expansão da partição principal e a montagem de um segundo disco, caso detectado.

#### Funcionalidades:
- Expande a partição principal (`/dev/sda1`) usando os comandos `growpart` e `resize2fs`.
- Verifica se existe um segundo disco em `/dev/vda`.
- Cria o ponto de montagem `/alterar` se ele não existir.
- Formata o segundo disco em `ext4` (se ainda não tiver um sistema de arquivos).
- Monta o disco `/dev/vda` em `/alterar`.
- Adiciona o disco ao arquivo `/etc/fstab` para montagem automática nos boots futuros.

#### Localização:
O script está localizado em:
```
/usr/local/bin/resize_disk.sh
```

### 2. **configure_host.sh**
Este script realiza a configuração inicial do host, incluindo ajustes no hostname e no arquivo `/etc/hosts`, com base nas informações obtidas da API do oVirt.

#### Funcionalidades:
- Aguarda a disponibilidade da rede antes de continuar a execução.
- Obtém o ID da VM a partir do sistema local.
- Consulta a API do oVirt para recuperar informações sobre a VM (como o nome).
- Configura o hostname temporário e permanente com o nome da VM.
- Atualiza o arquivo `/etc/hosts` com o hostname configurado.
- Atualiza o arquivo de configuração do Puppet (`/etc/puppetlabs/puppet/puppet.conf`) para refletir o hostname configurado.
- Gera logs detalhados em `/var/log/configure_host.log`.

#### Localização:
O script está localizado em:
```
/usr/local/bin/configure_host.sh
```

### 3. **remove_services.sh**
Este script é utilizado para desativar e remover os serviços associados aos scripts `resize_disk.sh` e `configure_host.sh` após a execução inicial, uma vez que eles não são mais necessários.

#### Funcionalidades:
- Desativa os serviços `resize-disk.service` e `configure-host.service`.
- Remove os arquivos de configuração dos serviços em `/etc/systemd/system`.
- Recarrega o `systemd` para aplicar as alterações.

#### Localização:
O script está localizado em:
```
/usr/local/bin/remove_services.sh
```

## Execução Automática

Os scripts são configurados para serem executados automaticamente durante o boot das VMs utilizando o `systemd`. 

### Configuração do Systemd

#### 1. **resize-disk.service**
Arquivo localizado em `/etc/systemd/system/resize-disk.service`:
```ini
[Unit]
Description=Redimensionar disco e sistema de arquivos no boot
After=local-fs.target
Requires=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/resize_disk.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

#### 2. **configure-host.service**
Arquivo localizado em `/etc/systemd/system/configure-host.service`:
```ini
[Unit]
Description=Configuração do Host
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/configure_host.sh
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
```

#### 3. **Ativação dos Serviços**
Execute os comandos abaixo para ativar os serviços:
```bash
systemctl enable resize-disk.service
systemctl enable configure-host.service
```

### Remoção dos Serviços
Após a execução inicial, o script `remove_services.sh` deve ser utilizado para desativar e remover os serviços:
```bash
/usr/local/bin/remove_services.sh
```

## Dependências

- **resize_disk.sh**:
  - `growpart`: Disponível nos pacotes `cloud-guest-utils` (Debian/Ubuntu) ou `cloud-utils-growpart` (Red Hat/CentOS).
  - `resize2fs`: Para ajustar o sistema de arquivos após a expansão da partição.
  - `mkfs.ext4`: Para formatar discos adicionais como `ext4`.

- **configure_host.sh**:
  - `curl`: Para realizar chamadas à API do oVirt.
  - `jq`: Para processar os dados retornados pela API em formato JSON.
  - `hostnamectl`: Para configuração do hostname.

- **remove_services.sh**:
  - `systemctl`: Para gerenciar os serviços do `systemd`.

## Logs

Os logs detalhados de cada execução estão localizados em:
- **resize_disk.sh**: Saída de erros e informações exibida no terminal.
- **configure_host.sh**: `/var/log/configure_host.log`

## Observações Importantes

- Certifique-se de que as credenciais para a API do oVirt (usuário e senha) estejam configuradas corretamente no script `configure_host.sh`.
- Os scripts foram projetados para serem executados em ambientes de VM gerenciados pelo oVirt e podem precisar de ajustes para outros cenários.
- Teste os scripts em um ambiente de desenvolvimento antes de implantá-los em produção.
