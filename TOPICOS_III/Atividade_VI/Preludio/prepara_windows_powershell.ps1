<#
.SYNOPSIS
    Script de Instalação e Configuração de Ambientes de Desenvolvimento para Windows x64.
.DESCRIPTION
    Instala Chocolatey, Dart, Flutter, VS Code, Git, OpenJDK, Android Studio,
    Python, Visual Studio Build Tools e cria a estrutura base do projeto Flutter.
.NOTES
    Execute como Administrador.
    Otimizado para Windows 10/11 x64.
#>

#Requires -RunAsAdministrator

# ====================================================================================================================
# Configurações Iniciais
# ====================================================================================================================
$ErrorActionPreference = 'Stop'
$ProgressPreference    = 'SilentlyContinue'   # Acelera downloads no Invoke-WebRequest

# Cores
$Red    = "`e[31m"
$Green  = "`e[32m"
$Yellow = "`e[33m"
$NC     = "`e[0m"

function Write-Log {
    param([string]$Message)
    Write-Host -ForegroundColor Green "[$(Get-Date -Format 'HH:mm:ss')] $Message"
}

function Write-Warn {
    param([string]$Message)
    Write-Host -ForegroundColor Yellow "[AVISO] $Message"
}

function Write-ErrorAndExit {
    param([string]$Message)
    Write-Host -ForegroundColor Red "[ERRO] $Message" -ForegroundColor Red
    exit 1
}

# ====================================================================================================================
# Função auxiliar: verifica se um comando existe no PATH
# ====================================================================================================================
function Test-Command {
    param([string]$Command)
    return [bool](Get-Command $Command -ErrorAction SilentlyContinue)
}

# ====================================================================================================================
# Função auxiliar: adiciona diretório ao PATH do usuário (permanente)
# ====================================================================================================================
function Add-ToUserPath {
    param([string]$Directory)

    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -split ';' -notcontains $Directory) {
        [Environment]::SetEnvironmentVariable(
            "Path",
            "$currentPath;$Directory",
            "User"
        )
        Write-Log "Adicionado ao PATH do usuário: $Directory"
    }
    # Atualiza a sessão atual
    $env:Path = "$env:Path;$Directory"
}

# ====================================================================================================================
# Etapa 0 – Chocolatey
# ====================================================================================================================
function Install-Chocolatey {
    if (Test-Command "choco") {
        Write-Log "Chocolatey já está instalado."
        return
    }

    Write-Log "Instalando Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

    # Recarrega o PATH para reconhecer o choco
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    if (-not (Test-Command "choco")) {
        Write-ErrorAndExit "Falha ao instalar o Chocolatey."
    }
    Write-Log "Chocolatey instalado com sucesso."
}

# ====================================================================================================================
# Etapa 1 – Pacotes Base
# ====================================================================================================================
function Install-BasePackages {
    Write-Log "Instalando pacotes base via Chocolatey..."

    $packages = @(
        "git",
        "vscode",
        "openjdk",
        "python3",
        "androidstudio",
        "visualstudio2022community",
        "visualstudio2022buildtools"
    )

    foreach ($pkg in $packages) {
        Write-Log "  -> Instalando $pkg ..."
        choco install $pkg -y --no-progress
        if ($LASTEXITCODE -ne 0) {
            Write-Warn "Falha ao instalar $pkg. Continuando..."
        }
    }

    Write-Log "Pacotes base instalados."
}

# ====================================================================================================================
# Etapa 2 – Dart SDK
# ====================================================================================================================
function Install-Dart {
    Write-Log "Verificando Dart SDK..."

    if (Test-Command "dart") {
        Write-Log "Dart já está instalado:"
        dart --version
        return
    }

    Write-Log "Instalando Dart SDK via Chocolatey..."
    choco install dart-sdk -y --no-progress

    if (-not (Test-Command "dart")) {
        # Chocolatey instala em C:\tools\dart-sdk
        $dartPath = "C:\tools\dart-sdk\bin"
        if (Test-Path $dartPath) {
            Add-ToUserPath $dartPath
        } else {
            Write-ErrorAndExit "Dart não encontrado após a instalação."
        }
    }

    Write-Log "Dart SDK instalado:"
    dart --version
}

# ====================================================================================================================
# Etapa 3 – Flutter
# ====================================================================================================================
function Install-Flutter {
    Write-Log "Verificando Flutter..."

    if (Test-Command "flutter") {
        Write-Log "Flutter já está instalado:"
        flutter --version
        return
    }

    Write-Log "Instalando Flutter via Chocolatey..."
    choco install flutter -y --no-progress

    # O Chocolatey instala o Flutter em C:\tools\flutter
    $flutterPath = "C:\tools\flutter\bin"
    if (Test-Path $flutterPath) {
        Add-ToUserPath $flutterPath
    } else {
        # Fallback: procura em locais comuns
        $possiblePaths = @(
            "C:\src\flutter\bin",
            "$env:USERPROFILE\flutter\bin",
            "$env:LOCALAPPDATA\flutter\bin"
        )
        foreach ($p in $possiblePaths) {
            if (Test-Path $p) {
                Add-ToUserPath $p
                $flutterPath = $p
                break
            }
        }
    }

    if (-not (Test-Command "flutter")) {
        Write-ErrorAndExit "Flutter não encontrado no PATH após a instalação."
    }

    Write-Log "Flutter instalado:"
    flutter --version

    # Aceita licenças do Android automaticamente (pode demorar)
    Write-Log "Aceitando licenças do Android SDK..."
    $yes = "y`n" * 10
    $yes | flutter doctor --android-licenses 2>&1 | Out-Null

    Write-Log "Executando flutter doctor..."
    flutter doctor
}

# ====================================================================================================================
# Etapa 4 – Criação do Projeto Flutter
# ====================================================================================================================
function Create-FlutterProject {
    Write-Log "Criando projeto Flutter..."

    $projectDir = Get-Location
    Write-Log "Diretório do projeto: $projectDir"

    # Cria o projeto Flutter
    flutter create --org com.grupo4topicos3.petcuida `
                   --platform android,ios `
                   --project-name petcuida `
                   ./

    if ($LASTEXITCODE -ne 0) {
        Write-ErrorAndExit "Falha ao criar o projeto Flutter."
    }

    Write-Log "Projeto Flutter criado com sucesso."
}

# ====================================================================================================================
# Etapa 5 – Assets
# ====================================================================================================================
function Download-Assets {
    Write-Log "Baixando assets..."

    $assetsDir = Join-Path (Get-Location) "assets"
    if (-not (Test-Path $assetsDir)) {
        New-Item -ItemType Directory -Path $assetsDir -Force | Out-Null
    }

    $logoUrl = "https://raw.githubusercontent.com/kasshinokun/Q3_Q4_2026_Public/main/TOPICOS_III/Atividade_VI/images/petcuida-logo.png"
    $logoPath = Join-Path $assetsDir "petcuida-logo.png"

    try {
        Invoke-WebRequest -Uri $logoUrl -OutFile $logoPath -UseBasicParsing
        Write-Log "Logo baixada: $logoPath"
    } catch {
        Write-Warn "Falha ao baixar a logo: $_"
    }

    # Remove pasta de testes padrão
    $testDir = Join-Path (Get-Location) "test"
    if (Test-Path $testDir) {
        Remove-Item -Recurse -Force $testDir
        Write-Log "Pasta 'test' removida."
    }
}

# ====================================================================================================================
# Etapa 6 – Estrutura de Pastas do Projeto (lib/)
# ====================================================================================================================
function Create-ProjectStructure {
    Write-Log "Criando estrutura de pastas em ./lib ..."

    $libDir = Join-Path (Get-Location) "lib"

    # Função auxiliar
    function New-ProjectFile {
        param([string]$RelativePath)
        $fullPath = Join-Path $libDir $RelativePath
        $dir = Split-Path $fullPath -Parent
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        if (-not (Test-Path $fullPath)) {
            New-Item -ItemType File -Path $fullPath -Force | Out-Null
            Write-Log "  [+] Criado: $RelativePath"
        } else {
            Write-Log "  [=] Já existe: $RelativePath"
        }
    }

    # Auth
    New-ProjectFile "features/auth/screens/splash_screen.dart"
    New-ProjectFile "features/auth/screens/login_screen.dart"
    New-ProjectFile "features/auth/screens/cadastro_screen.dart"
    New-ProjectFile "features/auth/screens/recuperar_senha_screen.dart"
    New-ProjectFile "features/auth/screens/onboarding_pet_screen.dart"

    # Home
    New-ProjectFile "features/home/screens/home_dashboard_screen.dart"

    # Pet
    New-ProjectFile "features/pet/screens/area_do_pet_screen.dart"
    New-ProjectFile "features/pet/screens/adicionar_editar_pet_screen.dart"
    New-ProjectFile "features/pet/screens/calendario_vacinas_screen.dart"
    New-ProjectFile "features/pet/screens/prontuario_historico_screen.dart"
    New-ProjectFile "features/pet/screens/gerar_qrcode_screen.dart"

    # Triagem
    New-ProjectFile "features/triagem/screens/triagem_orientativa_screen.dart"
    New-ProjectFile "features/triagem/screens/chat_orientacao_screen.dart"

    # Rede Solidária
    New-ProjectFile "features/rede_solidaria/screens/rede_solidaria_screen.dart"
    New-ProjectFile "features/rede_solidaria/screens/clinicas_usar_creditos_screen.dart"
    New-ProjectFile "features/rede_solidaria/screens/mapa_clinicas_screen.dart"
    New-ProjectFile "features/rede_solidaria/screens/agendamento_horario_screen.dart"
    New-ProjectFile "features/rede_solidaria/screens/checkout_hibrido_screen.dart"
    New-ProjectFile "features/rede_solidaria/screens/mural_pedidos_ofertas_screen.dart"

    # Perfil
    New-ProjectFile "features/perfil/screens/menu_perfil_screen.dart"
    New-ProjectFile "features/perfil/screens/saldo_extrato_screen.dart"
    New-ProjectFile "features/perfil/screens/meus_agendamentos_screen.dart"
    New-ProjectFile "features/perfil/screens/configuracoes_conta_screen.dart"
    New-ProjectFile "features/perfil/screens/suporte_ajuda_screen.dart"

    # Core
    $coreDirs = @("core/widgets", "core/models", "core/services")
    foreach ($d in $coreDirs) {
        $full = Join-Path $libDir $d
        if (-not (Test-Path $full)) {
            New-Item -ItemType Directory -Path $full -Force | Out-Null
        }
    }
    New-ProjectFile "core/routes/app_router.dart"

    Write-Log "Estrutura criada com sucesso em $libDir"
}

# ====================================================================================================================
# Execução Principal
# ====================================================================================================================
Write-Log "=== Iniciando configuração do ambiente Windows ==="

Install-Chocolatey
Install-BasePackages
Install-Dart
Install-Flutter
Create-FlutterProject
Download-Assets
Create-ProjectStructure

Write-Log "Abrindo VS Code..."
if (Test-Command "code") {
    code ./
} else {
    Write-Warn "VS Code não encontrado. Abra manualmente."
}

Write-Log "✅ Ambiente configurado com sucesso!"
Write-Log "Reinicie o terminal ou execute: refreshenv"
