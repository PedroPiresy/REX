# Sistema de Provisionamento de VMs (REX)

Este projeto implementa um pipeline de CI/CD no GitLab para automatizar o provisionamento de máquinas virtuais em ambientes RHEV (Red Hat Enterprise Virtualization) e OLVM (Oracle Linux Virtualization Manager).

## Visão Geral

O sistema permite a criação automatizada de VMs através de um pipeline GitLab, utilizando Ansible para a orquestração do processo de provisionamento. O projeto suporta múltiplos ambientes de virtualização e oferece uma interface flexível para configuração de recursos.

## Estrutura do Projeto

```
.
├── .gitlab-ci.yml          # Configuração do pipeline GitLab
├── ansible/
│   ├── inventory/         # Inventário Ansible
│   ├── playbooks/        # Playbooks de provisionamento
│   │   └── provision_vm.yml  # Playbook principal
│   └── vars/            # Variáveis e configurações
│       ├── vlan.yml     # Configurações de rede
│       └── storage_domains.yml  # Configurações de storage
├── pipeline/
│   └── variables.json    # Arquivo gerado com variáveis do pipeline
└── script_aux_template_vm/  # Scripts auxiliares
```

## Ambientes Suportados

### Engines de Virtualização
- RHEV (Red Hat Enterprise Virtualization)
- OLVM (Oracle Linux Virtualization Manager)
- Suporte a múltiplos engines simultâneos

### Redes (VLANs)
- **Ambientes de Desenvolvimento**
  - RMI (Rede Principal)
  - RMI_sec (Rede Secundária)

- **Ambientes de Homologação**
  - HML (Rede Principal)
  - HML_OLVM (Rede OLVM)
  - HML_sec (Rede Secundária)
  - DB_HML (Rede de Banco de Dados)

- **Ambientes de Produção**
  - PRD (Rede Principal)
  - PRD_OLVM (Rede OLVM)
  - PRD_sec (Rede Secundária)
  - DB_PRD (Rede de Banco de Dados)

- **Rede de Backup**
  - BKP (Rede de Backup)

### Storage Domains
- Suporte a múltiplos domínios de storage
- Seleção automática do storage com maior espaço disponível
- Configuração específica por ambiente

## Funcionalidades Principais

### 1. Provisionamento de VMs
- Criação automática de VMs
- Configuração de recursos (CPU, RAM, HD)
- Configuração de rede
- Seleção de template
- Configuração de timezone e layout de teclado

### 2. Gerenciamento de Discos
- Disco primário configurável
- Disco secundário opcional
- Expansão automática de discos
- Suporte a diferentes formatos (raw)

### 3. Configuração de Rede
- Múltiplas interfaces de rede
- Suporte a diferentes perfis de rede
- Configuração de VLANs
- Interface virtio

### 4. Templates Suportados
- Debian 11/12
- Red Hat 7/8
- Ubuntu 20/22

## Variáveis de Configuração

### Variáveis Obrigatórias
- `RHEV_URL`: URL do ambiente de virtualização
- `RHEV_USERNAME`: Usuário do RHEV
- `RHEV_PASSWORD`: Senha do RHEV
- `VM_NAME`: Nome do host para a máquina virtual

### Variáveis Opcionais
- `TEMPLATE`: Modelo de sistema operacional
  - Opções: Debian11_iac, Debian12_iac, RedHat7_iac, RedHat8_iac, Ubuntu20_iac, Ubuntu22_iac

- `CPU_CORES`: Número de núcleos de CPU
  - Opções: 1, 2, 4, 6, 8, 10, 12, 24, 32

- `RAM`: Quantidade de memória RAM
  - Opções: 1 GiB até 128 GiB

- `HD_1`: Tamanho do disco rígido primário
  - Opções: 20 GiB até 80 GiB

- `HD_2`: Tamanho do disco rígido secundário (opcional)
  - Opções: 0 até 100 GiB

- `VLAN`: VLAN primária da VM
  - Opções: RMI, HML, HML_OLVM, PRD, PRD_OLVM

- `VLAN_SECUNDARIA`: VLAN secundária da VM
  - Opções: null, RMI

## Fluxo de Execução

1. **Inicialização**
   - Pipeline é acionado (manual ou automático)
   - Validação de variáveis
   - Clonagem do repositório

2. **Preparação**
   - Configuração do ambiente remoto
   - Transferência do repositório
   - Geração do arquivo de variáveis

3. **Provisionamento**
   - Seleção do storage domain
   - Criação da VM
   - Configuração de recursos
   - Configuração de rede
   - Expansão de discos

4. **Finalização**
   - Inicialização da VM
   - Verificação de status
   - Limpeza de arquivos temporários

## Personalização

### 1. Modificação de Redes
- Editar `ansible/vars/vlan.yml`
- Adicionar novos perfis de rede
- Configurar interfaces específicas

### 2. Configuração de Storage
- Editar `ansible/vars/storage_domains.yml`
- Adicionar novos domínios de storage
- Configurar prioridades de seleção

### 3. Extensão do Playbook
- Modificar `ansible/playbooks/provision_vm.yml`
- Adicionar novas tasks
- Implementar validações personalizadas

## Boas Práticas

1. **Nomenclatura**
   - Use prefixos claros (dev-, hml-, prd-)
   - Mantenha padrão consistente
   - Documente convenções

2. **Recursos**
   - Comece com recursos mínimos
   - Monitore uso
   - Escale conforme necessidade

3. **Segurança**
   - Use VLANs apropriadas
   - Mantenha credenciais seguras
   - Revise permissões

4. **Manutenção**
   - Atualize templates
   - Documente alterações
   - Faça backup de configurações

## Suporte

Para suporte ou dúvidas, entre em contato com a equipe de infraestrutura.

## Guia de Uso Detalhado

### 1. Configuração Inicial

1. **Acesso ao GitLab**
   - Acesse o projeto no GitLab
   - Navegue até Settings > CI/CD > Variables
   - Configure as variáveis obrigatórias:
     ```
     RHEV_URL=https://seu-engine.example.com/ovirt-engine/api
     RHEV_USERNAME=seu_usuario
     RHEV_PASSWORD=sua_senha
     ```

2. **Configuração do Pipeline**
   - O pipeline pode ser executado de duas formas:
     - Manualmente: Vá até CI/CD > Pipelines > Run Pipeline
     - Automaticamente: Faça commit na branch main ou crie uma tag

### 2. Personalização de Recursos

#### 2.1 Configuração de Hardware
- **CPU**: Escolha entre 1 e 32 cores
  ```yaml
  CPU_CORES: 4  # Para uma VM com 4 cores
  ```
- **Memória**: Configure de 1 GiB até 128 GiB
  ```yaml
  RAM: "8 GiB"  # Para uma VM com 8GB de RAM
  ```
- **Armazenamento**: Configure até dois discos
  ```yaml
  HD_1: "40 GiB"  # Disco primário
  HD_2: "20 GiB"  # Disco secundário (opcional)
  ```

#### 2.2 Configuração de Rede
- **VLAN Primária**: Escolha o ambiente principal
  ```yaml
  VLAN: "HML"  # Para ambiente de homologação
  ```
- **VLAN Secundária**: Configure rede adicional se necessário
  ```yaml
  VLAN_SECUNDARIA: "RMI"  # Para acesso à rede de desenvolvimento
  ```

#### 2.3 Templates de Sistema Operacional
- **Debian**: Versões 11 e 12
  ```yaml
  TEMPLATE: "Debian12_iac"
  ```
- **Red Hat**: Versões 7 e 8
  ```yaml
  TEMPLATE: "RedHat8_iac"
  ```
- **Ubuntu**: Versões 20 e 22
  ```yaml
  TEMPLATE: "Ubuntu22_iac"
  ```

### 3. Casos de Uso Comuns

#### 3.1 Ambiente de Desenvolvimento
```yaml
VM_NAME: "dev-app-01"
TEMPLATE: "Ubuntu22_iac"
CPU_CORES: 2
RAM: "4 GiB"
HD_1: "20 GiB"
VLAN: "RMI"
```

#### 3.2 Ambiente de Homologação
```yaml
VM_NAME: "hml-app-01"
TEMPLATE: "RedHat8_iac"
CPU_CORES: 4
RAM: "8 GiB"
HD_1: "40 GiB"
HD_2: "20 GiB"
VLAN: "HML"
```

#### 3.3 Ambiente de Produção
```yaml
VM_NAME: "prd-app-01"
TEMPLATE: "RedHat8_iac"
CPU_CORES: 8
RAM: "16 GiB"
HD_1: "80 GiB"
HD_2: "40 GiB"
VLAN: "PRD"
```

### 4. Personalização Avançada

#### 4.1 Modificação do Pipeline
- O arquivo `.gitlab-ci.yml` pode ser modificado para:
  - Adicionar novos estágios
  - Incluir validações personalizadas
  - Modificar o fluxo de execução
  - Adicionar notificações

#### 4.2 Extensão do Ansible
- Os playbooks Ansible podem ser estendidos para:
  - Adicionar configurações pós-provisionamento
  - Implementar scripts de inicialização
  - Configurar monitoramento
  - Aplicar políticas de segurança

#### 4.3 Integração com Outras Ferramentas
- O sistema pode ser integrado com:
  - Sistemas de monitoramento
  - Ferramentas de backup
  - Sistemas de logging
  - Plataformas de orquestração

### 5. Boas Práticas

1. **Nomenclatura**
   - Use prefixos claros para VMs (dev-, hml-, prd-)
   - Mantenha um padrão consistente de nomes

2. **Recursos**
   - Comece com recursos mínimos e escale conforme necessário
   - Monitore o uso de recursos para otimização

3. **Segurança**
   - Use VLANs apropriadas para cada ambiente
   - Mantenha as credenciais seguras
   - Revise periodicamente as permissões

4. **Manutenção**
   - Mantenha os templates atualizados
   - Documente alterações significativas
   - Faça backup das configurações importantes

## Pré-requisitos

### Requisitos de Sistema
- GitLab Runner configurado
- Acesso SSH ao servidor remoto
- Credenciais de acesso ao ambiente RHEV/OLVM
- Ansible instalado no servidor remoto
- Python 3.6 ou superior
- Módulos Ansible:
  - ovirt.ovirt
  - community.general

### Permissões Necessárias
- Acesso de API ao RHEV/OLVM
- Permissões de criação de VMs
- Permissões de gerenciamento de storage
- Acesso às redes configuradas

## Configuração do Ambiente

### 1. Configuração do GitLab Runner
```yaml
# Exemplo de configuração do runner
[[runners]]
  name = "provision-runner"
  url = "https://gitlab.example.com"
  token = "seu-token"
  executor = "shell"
  [runners.custom]
    run_exec = "bash"
```

### 2. Configuração de Variáveis no GitLab
```yaml
# Variáveis obrigatórias
RHEV_URL: "https://engine-url.example.com/ovirt-engine/api"
RHEV_USERNAME: "admin@internal"
RHEV_PASSWORD: "sua-senha-segura"

# Variáveis opcionais
VM_NAME: "dev-app-01"
TEMPLATE: "Ubuntu22_iac"
CPU_CORES: 2
RAM: "4 GiB"
HD_1: "20 GiB"
VLAN: "RMI"
```

### 3. Configuração de Storage
```yaml
# Exemplo de configuração em storage_domains.yml
search_queries_engine:
  - "datadomain-dc1-alpha01"
  - "datadomain-dc1-alpha02"
  - "datadomain-dc1-alpha03"
```

### 4. Configuração de Rede
```yaml
# Exemplo de configuração em vlan.yml
nics_config:
  HML:
    - name: "enp1s0"
      profile_name: "net-hml-app"
      interface: virtio
```

## Processo de Provisionamento

### 1. Validação de Variáveis
- Verificação de variáveis obrigatórias
- Validação de formatos
- Verificação de compatibilidade

### 2. Seleção de Storage
- Análise de espaço disponível
- Seleção do storage domain mais adequado
- Verificação de permissões

### 3. Criação da VM
- Configuração de hardware
- Configuração de rede
- Aplicação de template
- Configuração de timezone

### 4. Configuração de Discos
- Expansão do disco principal
- Criação do disco secundário (se necessário)
- Verificação de espaço

### 5. Inicialização
- Primeiro boot
- Verificação de status
- Configuração final

## Troubleshooting

### Problemas Comuns

1. **Erro de Autenticação**
   ```bash
   # Verificar credenciais
   curl -k -u admin@internal:senha https://engine-url/ovirt-engine/api
   ```

2. **Erro de Storage**
   ```bash
   # Verificar espaço disponível
   ansible-playbook -i inventory check_storage.yml
   ```

3. **Erro de Rede**
   ```bash
   # Verificar conectividade
   ping engine-url
   ```

### Logs e Diagnóstico
- Logs do pipeline no GitLab
- Logs do Ansible em `/tmp/provision-${CI_JOB_ID}/`
- Logs do RHEV/OLVM

## Manutenção

### 1. Atualização de Templates
- Verificar compatibilidade
- Atualizar configurações
- Testar em ambiente de desenvolvimento

### 2. Backup de Configurações
- Backup do `.gitlab-ci.yml`
- Backup dos arquivos de variáveis
- Backup dos playbooks

### 3. Monitoramento
- Uso de recursos
- Espaço em storage
- Status das VMs

## Segurança

### 1. Credenciais
- Armazenamento seguro no GitLab
- Rotação periódica de senhas
- Uso de tokens de acesso

### 2. Redes
- Isolamento por VLAN
- Controle de acesso
- Monitoramento de tráfego

### 3. Storage
- Criptografia de dados
- Backup regular
- Controle de acesso

## Integração

### 1. Sistemas de Monitoramento
- Zabbix
- Prometheus
- Grafana

### 2. Sistemas de Backup
- Veeam
- Bacula
- Custom scripts

### 3. Sistemas de Logging
- ELK Stack
- Graylog
- Custom logging

## Desenvolvimento


## Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## Changelog

### v1.0.0
- Implementação inicial
- Suporte a RHEV
- Configuração básica

### v1.1.0
- Suporte a OLVM
- Novos templates
- Melhorias de performance

### v1.2.0
- Suporte a múltiplos storage domains
- Configuração de rede avançada
- Melhorias de segurança
