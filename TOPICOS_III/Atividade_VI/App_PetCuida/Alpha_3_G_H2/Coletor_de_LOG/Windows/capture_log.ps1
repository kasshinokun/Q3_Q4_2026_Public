<#
    Uso:
      .\capture_log.ps1 -c "flutter run" -o .\output
      .\capture_log.ps1 -Comando "flutter run" -ArquivoSaida .\output

    (a extensao ja foi definida .txt)
#>

param(
    [Parameter(Mandatory = $true)]
    [Alias("c")]
    [string]$Comando,

    [Parameter(Mandatory = $true)]
    [Alias("o")]
    [string]$ArquivoSaida
)

$Extension = ".txt"

# ---------- Cria o diretorio do arquivo de saida se nao existir ----------
$dir = Split-Path -Path $ArquivoSaida -Parent
if ($dir -and -not (Test-Path -Path $dir)) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

# Obs: ":" nao e permitido em nomes de arquivo no Windows, entao usamos "-" no timestamp do nome
$timestampArquivo = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
$startCapture = "$timestampArquivo$Extension"
$logFile = "$ArquivoSaida$startCapture"

# ---------- Escreve o cabecalho no log ----------
"=== INÍCIO DO LOG: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===" | Out-File -FilePath $logFile -Append -Encoding utf8
"Comando executado: $Comando" | Out-File -FilePath $logFile -Append -Encoding utf8
"--------------------------------------------------" | Out-File -FilePath $logFile -Append -Encoding utf8

# ---------- Executa o comando, mostra na tela em tempo real e salva no arquivo ----------
Invoke-Expression $Comando 2>&1 | Tee-Object -FilePath $logFile -Append

# ---------- Escreve o rodape apos o termino do comando ----------
"" | Out-File -FilePath $logFile -Append -Encoding utf8
"=== FIM DO LOG: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') ===" | Out-File -FilePath $logFile -Append -Encoding utf8

Write-Host "$logFile gravado com sucesso"
