# Versão A ==============================================> Ubuntu 24.04 x64

#!/bin/bash
# ====================================================================================================================
# Script de Instalação e Configuração de Ambientes de Desenvolvimento
# Otimizado para: Distros Linux x64 baseados em Ubuntu/Debian (Ubuntu 24.04+)
# ====================================================================================================================

set -e  # Interrompe o script em caso de erro
export DEBIAN_FRONTEND=noninteractive

# Cores para saída (opcional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # Sem cor

log() {
    echo -e "${GREEN}[$(date +%H:%M:%S)]${NC} $1"
}

error() {
    echo -e "${RED}[ERRO]${NC} $1" >&2
    exit 1
}

warn() {
    echo -e "${YELLOW}[AVISO]${NC} $1"
}

welcome() {
    log "Olá, vou lhe orientar para você recriar a estrutura"
    log "Estou preparado para Ubuntu 24.04 x64"
    log "ou Qualquer distro que use o APT"
}

etapa_0a() {
    log "0A - Atualizando sistema e instalando dependências essenciais..."

    sudo apt-get update -qq
    sudo apt-get install -y -qq wget gnupg

    # Em caso de erro descomente este trecho
    # Se usar distro igual ao Tsurugi Linux
    # wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /usr/share/keyrings/deb.torproject.org-keyring.gpg >/dev/null
    # wget -qO- https://deb.torproject.org/torproject.org/A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/deb.torproject.org.gpg >/dev/null
    # sudo apt-get clean

    sudo apt-get upgrade -y -qq

    # Agrupamento de pacotes (evita múltiplas chamadas apt)
    PACKAGES=(
        build-essential
        libssl-dev zlib1g-dev libgdbm-dev
        libreadline-dev libsqlite3-dev libffi-dev uuid-dev liblzma-dev tk-dev
        libncurses-dev
        curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config
        libgtk-3-dev libstdc++6 software-properties-common apt-transport-https
        default-jdk openjdk-21-jdk   # Apenas a versão LTS mais recente
    )

    sudo apt-get install -y -qq "${PACKAGES[@]}"

    # Habilita arquitetura i386 (necessário para Android SDK)
    sudo dpkg --add-architecture i386
    sudo apt-get update -qq
    sudo apt-get install -y -qq libc6:i386 libncurses6:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386
}

etapa_0b() {
    log "0B) Verificar presença do C"

    if command -v gcc &> /dev/null; then
        log "Encontrei o GCC"
        gcc --version | head -n1
    else
        warn "GCC não encontrado."
        sudo apt-get install -y gcc
    fi
}

etapa_0c() {
    log "0C) Verificar presença do C++"

    if command -v g++ &> /dev/null; then
        log "Encontrei o G++"
        g++ --version | head -n1
    else
        warn "G++ não encontrado."
        sudo apt-get install -y g++
    fi
}

etapa_0d() {
    log "0D) Verificar presença do Java"

    if command -v java &> /dev/null; then
        log "Encontrei o Java"
        java --version | head -n1
    else
        warn "Java não encontrado."
        sudo apt-get install -y default-jdk openjdk-21-jdk
    fi
}

etapa_0e() {
    log "0E) Checando se você tem o VS Code"

    if command -v code &> /dev/null; then
        log "Encontrei o VS Code"
        code --version | head -n1
    else
        warn "O VS Code não foi encontrado."
        if command -v snap &> /dev/null; then
            echo "Instalando VS Code via snap"
            sudo snap install code --classic
        else
            wget --show-progress "https://go.microsoft.com/fwlink/?LinkID=760868" -O /tmp/vscode.deb
            sudo apt-get install -y /tmp/vscode.deb
            rm -f /tmp/vscode.deb
        fi
    fi
}

etapa_1a() {
    log "Instalando/Atualizando Flutter (stable)..."

    FLUTTER_DIR="$HOME/development/flutter"
    FLUTTER_BIN="$FLUTTER_DIR/bin"
    mkdir -p "$(dirname "$FLUTTER_DIR")"

    if [ -d "$FLUTTER_DIR" ]; then
        log "Atualizando Flutter existente..."
        cd "$FLUTTER_DIR"
        git pull --ff-only origin stable
    else
        cd "$(dirname "$FLUTTER_DIR")"
        git clone https://github.com/flutter/flutter.git -b stable
    fi

    # Adiciona ao PATH permanentemente (sem depender de variável externa)
    if ! grep -qF "$FLUTTER_BIN" ~/.bashrc; then
        log "Adicionando ao PATH em ~/.bashrc"
        echo "export PATH=\"\$PATH:$FLUTTER_BIN\"" >> ~/.bashrc
    fi

    log "Adicionando ao Environment da sessão atual"
    export PATH="$PATH:$FLUTTER_BIN"

    log "1A) Verificar presença do DART e Flutter"

    if command -v dart &> /dev/null; then
        log "Encontrei o Dart SDK...."
        dart --version
    else
        log "Baixando Dart SDK...."
    fi

    if command -v flutter &> /dev/null; then
        log "Encontrei o Flutter SDK"
        flutter --version
    fi
}

stage_6a() {
    log "Instalando Android Studio..."

    android_studio_manual() {
        warn "Fazendo download manual do Android Studio..."
        ANDROID_STUDIO_URL="https://edgedl.me.gvt1.com/android/studio/ide-zips/2026.1.4.7/android-studio-quail4-linux.tar.gz"

        # -q ---------------> Silenciosamente
        # --show-progress --> Exibe progresso do download
        # -O ---------------> Especifica o arquivo a ser salvo
        wget --show-progress "$ANDROID_STUDIO_URL" -O /tmp/android-studio.tar.gz

        sudo tar -xzf /tmp/android-studio.tar.gz -C /opt/
        sudo ln -sf /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio
        rm -f /tmp/android-studio.tar.gz
    }

    android_studio_manual
}

stage_6b1() {
    log "Instruções para configurar o Android SDK"
    log "Instalando SDK e cmdline-tools via Android Studio"
    log "Passo 1: Abra o Android Studio."
    log "        Rode no terminal 'android-studio'"
    log "Passo 2: Abra o SDK Manager:"
    log "  A) Na tela de boas-vindas:"
    log "        Clique em More Actions (ou no ícone de três pontos)"
    log "        Clique em SDK Manager."
    log "  B) Com um projeto aberto:"
    log "        Vá em Tools"
    log "        SDK Manager (ou Settings/Preferences)"
    log "        Languages & Frameworks"
    log "        Android SDK"
    log "Passo 3: Selecione a aba SDK Platforms na parte superior."
    log "        Marque todos os android sdk do 8.0 até o atual[17] (em 14-09-2026, do 29.0 ao 37.0)"
    log "Passo 4: Selecione a aba SDK Tools na parte superior."
    log "Passo 5: Procure por Android SDK Command-line Tools (latest) e marque a caixa de seleção ao lado."
    log "Passo 6: Clique em Apply no canto inferior direito."
    log "Passo 7: Clique em OK para confirmar o download e aguarde a conclusão da instalação."
    log "Apos isto, é somente rodar no terminal 'flutter doctor --android-licenses'"
}

stage_6b2() {
    log "Configure o Android SDK"
    command -v android-studio >/dev/null || error "android-studio não encontrado no PATH."
    android-studio
    # O comando acima abre a GUI e trava o script até o Android Studio ser fechado.
}

stage_6b3() {
    log "Aceitando licenças do Android SDK (pode levar alguns minutos)..."
    yes | flutter doctor --android-licenses || warn "Falha ao aceitar licenças. Execute 'flutter doctor --android-licenses' manualmente."
}

stage_6b4() {
    log "Executando flutter doctor..."
    flutter doctor || warn "flutter doctor reportou pendências. Verifique a saída acima."
}

etapa_1b() {
    log "1B) Verificar status do Android Studio e preparativos"

    if command -v android-studio &> /dev/null; then
        log "Encontrei o Android Studio"
    else
        stage_6a # Instalação
    fi

    log "Verificação do Android Studio e Validação"
    stage_6b1 # Dicas
    stage_6b2 # Finalização
    stage_6b3 # Licenças
    stage_6b4 # Doctor

    log "Tudo está pronto!"
}

etapa_2a() {
    log "2A) Criando o projeto"
    flutter create --org com.grupo4topicos3.petcuida --platform android,ios --project-name petcuida ./

    log "Criando pasta para assets"
    mkdir -p ./assets

    # URL precisa ser o link "raw" do GitHub, não o link da página "blob"
    LOGO_URL="https://raw.githubusercontent.com/kasshinokun/Q3_Q4_2026_Public/main/TOPICOS_III/Atividade_VI/images/petcuida-logo.png"

    # -q ---------------> Silenciosamente
    # --show-progress --> Exibe progresso do download
    # -O ---------------> Especifica o arquivo a ser salvo
    wget -q --show-progress "$LOGO_URL" -O ./assets/petcuida-logo.png

    log "Projeto criado com sucesso, estou abrindo o VS Code"
    rm -rf ./test
}

etapa_2b() {
    # ============================================================
    # Cria a estrutura de pastas e arquivos .dart (vazios) dentro
    # de ./lib para o projeto Flutter, organizada por feature.
    # ============================================================

    LIB_DIR="./lib"

    log "Criando estrutura de pastas e arquivos em $LIB_DIR ..."

    # ------------------------------------------------------------
    # Função utilitária: cria a pasta (se não existir) e o arquivo
    # ------------------------------------------------------------
    create_file() {
        local filepath="$1"
        local dir
        dir=$(dirname "$filepath")
        mkdir -p "$dir"
        if [ ! -f "$filepath" ]; then
            touch "$filepath"
            log "  [+] Criado: $filepath"
        else
            log "  [=] Já existe: $filepath"
        fi
    }

    # FEATURE: auth
    create_file "$LIB_DIR/features/auth/screens/splash_screen.dart"
    create_file "$LIB_DIR/features/auth/screens/login_screen.dart"
    create_file "$LIB_DIR/features/auth/screens/cadastro_screen.dart"
    create_file "$LIB_DIR/features/auth/screens/recuperar_senha_screen.dart"
    create_file "$LIB_DIR/features/auth/screens/onboarding_pet_screen.dart"

    # FEATURE: home
    create_file "$LIB_DIR/features/home/screens/home_dashboard_screen.dart"

    # FEATURE: pet
    create_file "$LIB_DIR/features/pet/screens/area_do_pet_screen.dart"
    create_file "$LIB_DIR/features/pet/screens/adicionar_editar_pet_screen.dart"
    create_file "$LIB_DIR/features/pet/screens/calendario_vacinas_screen.dart"
    create_file "$LIB_DIR/features/pet/screens/prontuario_historico_screen.dart"
    create_file "$LIB_DIR/features/pet/screens/gerar_qrcode_screen.dart"

    # FEATURE: triagem
    create_file "$LIB_DIR/features/triagem/screens/triagem_orientativa_screen.dart"
    create_file "$LIB_DIR/features/triagem/screens/chat_orientacao_screen.dart"

    # FEATURE: rede_solidaria
    create_file "$LIB_DIR/features/rede_solidaria/screens/rede_solidaria_screen.dart"
    create_file "$LIB_DIR/features/rede_solidaria/screens/clinicas_usar_creditos_screen.dart"
    create_file "$LIB_DIR/features/rede_solidaria/screens/mapa_clinicas_screen.dart"
    create_file "$LIB_DIR/features/rede_solidaria/screens/agendamento_horario_screen.dart"
    create_file "$LIB_DIR/features/rede_solidaria/screens/checkout_hibrido_screen.dart"
    create_file "$LIB_DIR/features/rede_solidaria/screens/mural_pedidos_ofertas_screen.dart"

    # FEATURE: perfil
    create_file "$LIB_DIR/features/perfil/screens/menu_perfil_screen.dart"
    create_file "$LIB_DIR/features/perfil/screens/saldo_extrato_screen.dart"
    create_file "$LIB_DIR/features/perfil/screens/meus_agendamentos_screen.dart"
    create_file "$LIB_DIR/features/perfil/screens/configuracoes_conta_screen.dart"
    create_file "$LIB_DIR/features/perfil/screens/suporte_ajuda_screen.dart"

    # Estrutura comum (widgets, rotas, modelos) - pastas base
    mkdir -p "$LIB_DIR/core/widgets"
    mkdir -p "$LIB_DIR/core/models"
    mkdir -p "$LIB_DIR/core/services"
    create_file "$LIB_DIR/core/routes/app_router.dart"

    log "Estrutura criada com sucesso em $LIB_DIR"
    log "Total de telas: 24 (+ arquivo de rotas)"
}

stage_0() {
    etapa_0a
    etapa_0b
    etapa_0c
    etapa_0d
    etapa_0e
}

stage_1() {
    etapa_1a
    etapa_1b
}

stage_2() {
    etapa_2a
    etapa_2b
}

# Execução principal
welcome
stage_0
stage_1
stage_2

log "Abrindo Code ..."
code ./ || warn "Não foi possível abrir o VS Code."
