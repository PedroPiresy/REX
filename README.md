# REX

REX é uma solução de Infrastructure as Code (IaC) para automatizar o provisionamento de máquinas virtuais em ambientes que utilizam oVirt Engine (anteriormente conhecido como Red Hat Enterprise Virtualization - RHEV) como plataforma de virtualização. O projeto suporta tanto ambientes Red Hat quanto Oracle que utilizem oVirt Engine como base.

## 🚀 Funcionalidades
- Provisionamento automático de VMs via GitLab CI/CD
- Suporte a múltiplos ambientes oVirt Engine
- Configuração flexível de recursos (CPU, RAM, HD)
- Gerenciamento de redes e VLANs
- Suporte a diversos templates de sistema operacional
- Integração com Oracle Linux Virtualization Manager (OLVM)

## 🛠️ Tecnologias Utilizadas
- GitLab CI/CD
- Ansible
- oVirt Engine API
- Shell Script
- JSON

## 📦 Estrutura do Projeto
```
.
├── .gitlab-ci.yml          # Configuração do pipeline GitLab
├── ansible/               # Diretório de playbooks e configurações Ansible
│   ├── inventory/        # Inventários Ansible
│   ├── playbooks/       # Playbooks de provisionamento
│   └── vars/           # Variáveis Ansible
└── pipeline/            # Arquivos de pipeline
    └── variables.json   # Template de variáveis
```

## ⚙️ Configuração

### Pré-requisitos
- GitLab Runner configurado
- Acesso ao oVirt Engine
- Credenciais de API do oVirt Engine
- Ansible instalado no ambiente de execução

### Variáveis de Ambiente
O pipeline utiliza as seguintes variáveis principais:
- `RHEV_URL`: URL do ambiente oVirt Engine
- `RHEV_USERNAME`: Usuário de API
- `RHEV_PASSWORD`: Senha de API
- `VM_NAME`: Nome da VM a ser provisionada
- `TEMPLATE`: Template de sistema operacional
- `CPU_CORES`: Número de cores de CPU
- `RAM`: Quantidade de memória RAM
- `HD_1`: Tamanho do disco principal
- `HD_2`: Tamanho do disco secundário (opcional)
- `VLAN`: VLAN primária
- `VLAN_SECUNDARIA`: VLAN secundária (opcional)

## 🚀 Uso

### 1. Configuração do Pipeline
1. Configure as variáveis no GitLab CI/CD
2. Selecione o ambiente oVirt Engine
3. Defina os parâmetros da VM

### 2. Execução
O pipeline pode ser executado de duas formas:
- Manualmente através da interface do GitLab
- Automaticamente via tags ou branch main

### 3. Monitoramento
- Logs detalhados disponíveis no GitLab CI/CD
- Status do provisionamento em tempo real
- Notificações de sucesso/falha

## 🔒 Segurança
- Credenciais armazenadas de forma segura
- Comunicação via HTTPS
- Validações de permissões
- Controle de acesso via VLANs

## 🌐 Ambientes Suportados
- Desenvolvimento (RMI)
- Homologação (HML)
- Produção (PRD)
- Disaster Recovery (DR)
- Oracle Linux Virtualization (OLVM)

## 📝 Templates Suportados
- Debian 11/12
- Red Hat 7/8
- Ubuntu 20/22
- CentOS 7/8/9

## 🔄 Fluxo de Trabalho
1. Configuração inicial no GitLab
2. Validação de variáveis
3. Conexão com oVirt Engine
4. Provisionamento da VM
5. Configuração de rede
6. Verificação final

## 🛠️ Manutenção
- Atualização de templates
- Ajuste de recursos
- Modificação de VLANs
- Adição de novos ambientes

## 📚 Documentação Adicional
- [Documentação do oVirt Engine](https://www.ovirt.org/documentation/)
- [Documentação do Ansible](https://docs.ansible.com/)
- [Documentação do GitLab CI/CD](https://docs.gitlab.com/ee/ci/)

## 🤝 Contribuição
1. Fork o projeto
2. Crie sua branch de feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abra um Pull Request

## 📄 Licença
Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para mais detalhes.

## 📞 Suporte
Para suporte, entre em contato com a equipe de infraestrutura ou abra uma issue no projeto.
