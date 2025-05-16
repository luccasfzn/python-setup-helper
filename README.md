# Configurador do PATH do Python para Windows

Este utilitário ajuda a configurar corretamente o PATH do sistema Windows para incluir o Python e seu diretório Scripts, resolvendo o erro comum:

```
Python não foi encontrado; executar sem argumentos para instalar do Microsoft Store ou desabilitar este atalho em Configurações > Aplicativos > Configurações avançadas do aplicativo > Aliases de execução do aplicativo.
```

## Como usar

### Método 1: Executar diretamente do GitHub

1. Abra o PowerShell como Administrador
2. Execute o comando:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/luccasfzn/python-setup-helper/main/setup-python-path.ps1'))
```

### Método 2: Download e execução manual

1. Baixe o arquivo [setup-python-path.ps1](https://raw.githubusercontent.com/luccasfzn/python-setup-helper/main/setup-python-path.ps1)
2. Abra o PowerShell como Administrador
3. Navegue até o diretório onde o arquivo foi baixado
4. Execute:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\setup-python-path.ps1
```

## O que este script faz

- Verifica se está sendo executado como Administrador
- Procura instalações do Python em locais comuns do sistema
- Adiciona os diretórios do Python e Scripts ao PATH do sistema
- Verifica se a configuração foi bem-sucedida
- Testa se o comando `python` está funcionando

## Requisitos

- Windows 10 ou superior
- PowerShell 5.1 ou superior
- Permissões de Administrador
- Python já instalado no sistema (se não estiver, o script recomendará a instalação)

## Solução de problemas

Se após executar o script você ainda não conseguir usar o comando `python` no terminal:

1. Certifique-se de ter reiniciado o terminal após a execução do script
2. Verifique se o Python está instalado corretamente usando o instalador oficial
3. Durante a instalação do Python, certifique-se de marcar a opção "Add Python to PATH"

## Licença

MIT