#!/bin/bash

# Inicializa as variáveis
COMANDO=""
ARQUIVO_SAIDA=""
EXTENSION=".txt"
# Processa as flags -c e -o
while getopts "c:o:" opt; do
  case $opt in
    c) COMANDO="$OPTARG" ;;
    o) ARQUIVO_SAIDA="$OPTARG" ;;
    *) echo "Uso: $0 -c \"comando\" -o nome_arquivo(a extensao ja foi definida(.txt))"; exit 1 ;;
  esac
done

# Valida se os argumentos obrigatórios foram passados
if [ -z "$COMANDO" ] || [ -z "$ARQUIVO_SAIDA" ]; then
    echo "Erro: Você precisa especificar o comando (-c) e o arquivo de saída (-o)."
    echo "Exemplo: $0 -c \"flutter run\" -o ./output (a extensao ja foi definida(.txt))"
    exit 1
fi



# Cria o diretório do arquivo de saída se não existir
mkdir -p "$(dirname "$ARQUIVO_SAIDA")"


START_CAPTURE="$(date '+%Y-%m-%d %H:%M:%S')$EXTENSION"

# Escreve um cabeçalho no log com o momento do início
echo "=== INÍCIO DO LOG: $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$ARQUIVO_SAIDA$START_CAPTURE"
echo "Comando executado: $COMANDO" >> "$ARQUIVO_SAIDA$START_CAPTURE"
echo "--------------------------------------------------" >> "$ARQUIVO_SAIDA$START_CAPTURE"

# Executa o comando, mostra na tela em tempo real e salva os erros/saídas no arquivo
eval "$COMANDO" 2>&1 | tee -a "$ARQUIVO_SAIDA$START_CAPTURE"

# Escreve o rodapé após o término do comando
echo "" >> "$ARQUIVO_SAIDA$START_CAPTURE"
echo "=== FIM DO LOG: $(date '+%Y-%m-%d %H:%M:%S') ===" >> "$ARQUIVO_SAIDA$START_CAPTURE"
echo "$ARQUIVO_SAIDA$START_CAPTURE gravado com sucesso"
