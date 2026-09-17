@echo off
setlocal enabledelayedexpansion

set "COMANDO="
set "ARQUIVO_SAIDA="
set "EXTENSION=.txt"

:: ---------- Processa as flags -c e -o ----------
:parse_args
if "%~1"=="" goto check_args

if /i "%~1"=="-c" (
    set "COMANDO=%~2"
    shift
    shift
    goto parse_args
)

if /i "%~1"=="-o" (
    set "ARQUIVO_SAIDA=%~2"
    shift
    shift
    goto parse_args
)

echo Uso: %~nx0 -c "comando" -o nome_arquivo (a extensao ja foi definida .txt)
exit /b 1

:: ---------- Valida se os argumentos obrigatorios foram passados ----------
:check_args
if "%COMANDO%"=="" goto erro
if "%ARQUIVO_SAIDA%"=="" goto erro
goto main

:erro
echo Erro: Voce precisa especificar o comando (-c) e o arquivo de saida (-o).
echo Exemplo: %~nx0 -c "flutter run" -o .\output (a extensao ja foi definida .txt)
exit /b 1

:main

:: ---------- Cria o diretorio do arquivo de saida se nao existir ----------
for %%F in ("%ARQUIVO_SAIDA%") do set "DIR_SAIDA=%%~dpF"
if not "%DIR_SAIDA%"=="" if not exist "%DIR_SAIDA%" mkdir "%DIR_SAIDA%" >nul 2>&1

:: ---------- Gera o timestamp (usando PowerShell para garantir formato consistente) ----------
:: Obs: ":" nao e permitido em nomes de arquivo no Windows, entao usamos "-" no lugar
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd_HH-mm-ss\""') do set "TIMESTAMP=%%i"
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "TIMESTAMP_LEGIVEL=%%i"

set "START_CAPTURE=%TIMESTAMP%%EXTENSION%"
set "LOGFILE=%ARQUIVO_SAIDA%%START_CAPTURE%"

:: ---------- Escreve o cabecalho no log ----------
echo === INICIO DO LOG: %TIMESTAMP_LEGIVEL% === >> "%LOGFILE%"
echo Comando executado: %COMANDO% >> "%LOGFILE%"
echo -------------------------------------------------- >> "%LOGFILE%"

:: ---------- Executa o comando, mostra na tela em tempo real e salva no arquivo ----------
:: O "cmd /c" permite rodar comandos compostos como no eval do bash
cmd /c %COMANDO% > "%TEMP%\capture_log_tmp.txt" 2>&1
type "%TEMP%\capture_log_tmp.txt"
type "%TEMP%\capture_log_tmp.txt" >> "%LOGFILE%"
del "%TEMP%\capture_log_tmp.txt" >nul 2>&1

:: ---------- Escreve o rodape apos o termino do comando ----------
for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format \"yyyy-MM-dd HH:mm:ss\""') do set "TIMESTAMP_FIM=%%i"
echo. >> "%LOGFILE%"
echo === FIM DO LOG: %TIMESTAMP_FIM% === >> "%LOGFILE%"

echo %LOGFILE% gravado com sucesso

endlocal
