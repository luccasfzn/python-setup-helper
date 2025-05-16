# Script para configurar o PATH do Python no Windows
# Autor: Cascade AI
# Data: 16/05/2025

# Executar como administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Este script precisa ser executado como Administrador para modificar variáveis de ambiente do sistema."
    Write-Warning "Por favor, reinicie o PowerShell como Administrador e execute este script novamente."
    exit
}

# Função para encontrar instalações do Python
function Find-PythonInstallations {
    $pythonLocations = @()
    
    # Locais comuns de instalação do Python
    $commonLocations = @(
        "C:\Python*",
        "C:\Program Files\Python*",
        "C:\Program Files (x86)\Python*",
        "$env:LOCALAPPDATA\Programs\Python\Python*"
    )
    
    foreach ($location in $commonLocations) {
        if (Test-Path $location) {
            $pythonLocations += Get-Item $location
        }
    }
    
    return $pythonLocations
}

# Função para verificar se um caminho já está no PATH
function Test-PathExists {
    param (
        [string]$PathToCheck
    )
    
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
    $pathEntries = $currentPath -split ";"
    
    return $pathEntries -contains $PathToCheck
}

# Função para adicionar um caminho ao PATH
function Add-ToPath {
    param (
        [string]$NewPath
    )
    
    if (-not (Test-PathExists $NewPath)) {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        $newPathValue = $currentPath + ";" + $NewPath
        
        try {
            [Environment]::SetEnvironmentVariable("Path", $newPathValue, "Machine")
            Write-Host "Adicionado ao PATH: $NewPath" -ForegroundColor Green
            return $true
        }
        catch {
            Write-Host "Erro ao adicionar ao PATH: $($_.Exception.Message)" -ForegroundColor Red
            return $false
        }
    }
    else {
        Write-Host "Já existe no PATH: $NewPath" -ForegroundColor Yellow
        return $true
    }
}

# Função principal
function Configure-PythonPath {
    $pythonInstallations = Find-PythonInstallations
    
    if ($pythonInstallations.Count -eq 0) {
        Write-Host "Nenhuma instalação do Python foi encontrada." -ForegroundColor Red
        Write-Host "Por favor, instale o Python do site oficial: https://www.python.org/downloads/" -ForegroundColor Yellow
        return $false
    }
    
    Write-Host "Encontradas $($pythonInstallations.Count) instalações do Python:" -ForegroundColor Cyan
    
    $successCount = 0
    
    foreach ($installation in $pythonInstallations) {
        Write-Host "Configurando: $($installation.FullName)" -ForegroundColor Cyan
        
        # Adicionar o diretório principal do Python
        $mainPath = $installation.FullName
        $success = Add-ToPath $mainPath
        if ($success) { $successCount++ }
        
        # Adicionar o diretório Scripts
        $scriptsPath = Join-Path $mainPath "Scripts"
        if (Test-Path $scriptsPath) {
            $success = Add-ToPath $scriptsPath
            if ($success) { $successCount++ }
        }
    }
    
    if ($successCount -gt 0) {
        Write-Host "`nConfigurações do PATH concluídas com sucesso!" -ForegroundColor Green
        Write-Host "Por favor, reinicie qualquer terminal aberto para que as alterações tenham efeito." -ForegroundColor Yellow
        return $true
    }
    else {
        Write-Host "`nNenhuma alteração foi feita ao PATH." -ForegroundColor Yellow
        return $false
    }
}

# Executar a configuração
Write-Host "=== Configurador do PATH do Python ===" -ForegroundColor Cyan
Write-Host "Este script irá configurar o PATH do sistema para incluir o Python e o diretório Scripts." -ForegroundColor Cyan
Write-Host "Pressione qualquer tecla para continuar ou CTRL+C para cancelar..." -ForegroundColor Yellow
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

$result = Configure-PythonPath

if ($result) {
    # Verificar se o Python está acessível
    Write-Host "`nTestando a configuração do Python..." -ForegroundColor Cyan
    
    try {
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
        $pythonVersion = & python --version 2>&1
        Write-Host "Python está configurado corretamente: $pythonVersion" -ForegroundColor Green
    }
    catch {
        Write-Host "Python ainda não está acessível no terminal atual." -ForegroundColor Yellow
        Write-Host "Por favor, reinicie o PowerShell e tente executar 'python --version'" -ForegroundColor Yellow
    }
}

Write-Host "`nPressione qualquer tecla para sair..." -ForegroundColor Cyan
$null = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")