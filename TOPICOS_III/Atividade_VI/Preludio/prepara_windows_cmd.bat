@echo off
setlocal EnableDelayedExpansion

:: ====================================================================================================================
:: Script de Instalação e Configuração de Ambientes de Desenvolvimento para Windows x64
:: Usa Chocolatey para instalar Dart, Flutter e demais ferramentas.
:: Execute como Administrador.
:: ====================================================================================================================

:: Verifica se está rodando como Administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERRO] Este script precisa ser executado como Administrador.
    pause
    exit /b 1
)

echo =====================================================
echo  Instalando ambiente de desenvolvimento (Windows)
echo =====================================================

:: --------------------------------------------------------------------------------------------------------------------
:: 1. Chocolatey
:: --------------------------------------------------------------------------------------------------------------------
where choco >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Instalando Chocolatey...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "Set-ExecutionPolicy Bypass -Scope Process -Force; ^
         [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; ^
         iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"
    if %errorLevel% neq 0 (
        echo [ERRO] Falha ao instalar o Chocolatey.
        pause
        exit /b 1
    )
    :: Recarrega o PATH
    call :RefreshEnv
) else (
    echo [INFO] Chocolatey já instalado.
)

:: --------------------------------------------------------------------------------------------------------------------
:: 2. Pacotes Base
:: --------------------------------------------------------------------------------------------------------------------
echo [INFO] Instalando pacotes base...
choco install git vscode openjdk python3 androidstudio visualstudio2022community visualstudio2022buildtools -y --no-progress
if %errorLevel% neq 0 (
    echo [AVISO] Algum pacote base falhou. Continuando...
)

:: --------------------------------------------------------------------------------------------------------------------
:: 3. Dart SDK
:: --------------------------------------------------------------------------------------------------------------------
where dart >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Instalando Dart SDK...
    choco install dart-sdk -y --no-progress
    if %errorLevel% neq 0 (
        echo [ERRO] Falha ao instalar Dart SDK.
        pause
        exit /b 1
    )
    :: Adiciona ao PATH se necessário
    set "DART_PATH=C:\tools\dart-sdk\bin"
    if exist "!DART_PATH!" (
        setx PATH "!PATH!;!DART_PATH!" /M >nul
        set "PATH=!PATH!;!DART_PATH!"
    )
) else (
    echo [INFO] Dart já instalado.
    dart --version
)

:: --------------------------------------------------------------------------------------------------------------------
:: 4. Flutter
:: --------------------------------------------------------------------------------------------------------------------
where flutter >nul 2>&1
if %errorLevel% neq 0 (
    echo [INFO] Instalando Flutter...
    choco install flutter -y --no-progress
    if %errorLevel% neq 0 (
        echo [ERRO] Falha ao instalar Flutter.
        pause
        exit /b 1
    )
    :: Adiciona ao PATH
    set "FLUTTER_PATH=C:\tools\flutter\bin"
    if exist "!FLUTTER_PATH!" (
        setx PATH "!PATH!;!FLUTTER_PATH!" /M >nul
        set "PATH=!PATH!;!FLUTTER_PATH!"
    ) else (
        :: Tenta locais alternativos
        for %%P in ("C:\src\flutter\bin" "%USERPROFILE%\flutter\bin" "%LOCALAPPDATA%\flutter\bin") do (
            if exist "%%~P" (
                setx PATH "!PATH!;%%~P" /M >nul
                set "PATH=!PATH!;%%~P"
                goto :flutter_found
            )
        )
        echo [ERRO] Flutter não encontrado após a instalação.
        pause
        exit /b 1
    )
    :flutter_found
) else (
    echo [INFO] Flutter já instalado.
    flutter --version
)

:: Aceita licenças do Android automaticamente
echo [INFO] Aceitando licenças do Android SDK...
(
    echo y
    echo y
    echo y
    echo y
    echo y
    echo y
    echo y
    echo y
    echo y
    echo y
) | flutter doctor --android-licenses >nul 2>&1

echo [INFO] Executando flutter doctor...
flutter doctor

:: --------------------------------------------------------------------------------------------------------------------
:: 5. Criação do Projeto Flutter
:: --------------------------------------------------------------------------------------------------------------------
echo [INFO] Criando projeto Flutter...
flutter create --org com.grupo4topicos3.petcuida --platform android,ios --project-name petcuida ./
if %errorLevel% neq 0 (
    echo [ERRO] Falha ao criar o projeto Flutter.
    pause
    exit /b 1
)

:: --------------------------------------------------------------------------------------------------------------------
:: 6. Assets
:: --------------------------------------------------------------------------------------------------------------------
echo [INFO] Criando pasta de assets...
if not exist "assets" mkdir assets

echo [INFO] Baixando logo...
powershell -NoProfile -Command ^
    "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/kasshinokun/Q3_Q4_2026_Public/main/TOPICOS_III/Atividade_VI/images/petcuida-logo.png' -OutFile 'assets\petcuida-logo.png' -UseBasicParsing"

:: Remove pasta de testes padrão
if exist "test" (
    rmdir /s /q test
    echo [INFO] Pasta 'test' removida.
)

:: --------------------------------------------------------------------------------------------------------------------
:: 7. Estrutura de pastas do projeto (lib/)
:: --------------------------------------------------------------------------------------------------------------------
echo [INFO] Criando estrutura de pastas em .\lib ...

:: Auth
call :CreateFile "lib\features\auth\screens\splash_screen.dart"
call :CreateFile "lib\features\auth\screens\login_screen.dart"
call :CreateFile "lib\features\auth\screens\cadastro_screen.dart"
call :CreateFile "lib\features\auth\screens\recuperar_senha_screen.dart"
call :CreateFile "lib\features\auth\screens\onboarding_pet_screen.dart"

:: Home
call :CreateFile "lib\features\home\screens\home_dashboard_screen.dart"

:: Pet
call :CreateFile "lib\features\pet\screens\area_do_pet_screen.dart"
call :CreateFile "lib\features\pet\screens\adicionar_editar_pet_screen.dart"
call :CreateFile "lib\features\pet\screens\calendario_vacinas_screen.dart"
call :CreateFile "lib\features\pet\screens\prontuario_historico_screen.dart"
call :CreateFile "lib\features\pet\screens\gerar_qrcode_screen.dart"

:: Triagem
call :CreateFile "lib\features\triagem\screens\triagem_orientativa_screen.dart"
call :CreateFile "lib\features\triagem\screens\chat_orientacao_screen.dart"

:: Rede Solidária
call :CreateFile "lib\features\rede_solidaria\screens\rede_solidaria_screen.dart"
call :CreateFile "lib\features\rede_solidaria\screens\clinicas_usar_creditos_screen.dart"
call :CreateFile "lib\features\rede_solidaria\screens\mapa_clinicas_screen.dart"
call :CreateFile "lib\features\rede_solidaria\screens\agendamento_horario_screen.dart"
call :CreateFile "lib\features\rede_solidaria\screens\checkout_hibrido_screen.dart"
call :CreateFile "lib\features\rede_solidaria\screens\mural_pedidos_ofertas_screen.dart"

:: Perfil
call :CreateFile "lib\features\perfil\screens\menu_perfil_screen.dart"
call :CreateFile "lib\features\perfil\screens\saldo_extrato_screen.dart"
call :CreateFile "lib\features\perfil\screens\meus_agendamentos_screen.dart"
call :CreateFile "lib\features\perfil\screens\configuracoes_conta_screen.dart"
call :CreateFile "lib\features\perfil\screens\suporte_ajuda_screen.dart"

:: Core
if not exist "lib\core\widgets" mkdir "lib\core\widgets"
if not exist "lib\core\models" mkdir "lib\core\models"
if not exist "lib\core\services" mkdir "lib\core\services"
call :CreateFile "lib\core\routes\app_router.dart"

echo [INFO] Estrutura criada com sucesso.

:: --------------------------------------------------------------------------------------------------------------------
:: 8. Abrir VS Code
:: --------------------------------------------------------------------------------------------------------------------
echo [INFO] Abrindo VS Code...
where code >nul 2>&1
if %errorLevel% equ 0 (
    start "" code ./
) else (
    echo [AVISO] VS Code não encontrado. Abra manualmente.
)

echo.
echo =====================================================
echo  ✅ Ambiente configurado com sucesso!
echo  Reinicie o terminal ou execute: refreshenv
echo =====================================================
pause
exit /b 0

:: ====================================================================================================================
:: Sub-rotinas
:: ====================================================================================================================

:CreateFile
:: Cria um arquivo (e seus diretórios pais) se não existir
set "FILEPATH=%~1"
for %%F in ("%FILEPATH%") do set "DIRPATH=%%~dpF"
if not exist "%DIRPATH%" mkdir "%DIRPATH%"
if not exist "%FILEPATH%" (
    type nul > "%FILEPATH%"
    echo   [+] Criado: %FILEPATH%
) else (
    echo   [=] Já existe: %FILEPATH%
)
exit /b 0

:RefreshEnv
:: Recarrega variáveis de ambiente a partir do registro
for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path 2^>nul') do set "SYS_PATH=%%B"
for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v Path 2^>nul') do set "USR_PATH=%%B"
set "PATH=%SYS_PATH%;%USR_PATH%"
exit /b 0
